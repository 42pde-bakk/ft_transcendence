class GuildsController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :connect_user
  before_action :set_guild, only: [:show, :edit, :update, :destroy, :join, :add_points]
  before_action :has_guild, only: [:create, :join]

  def index
    @guilds = Guild.all
    @guilds = @guilds.sort_by(&:points).reverse
    render json: @guilds
  end

  def users_available
    @current_user.last_seen = DateTime.now
    @current_user.save
    @users = User.all.where.not(:id => @current_user.id)
    @users = @users.all.where(:guild_id => nil)
    respond_to do |format|
      format.html { redirect_to "/", notice: '^^' }
      format.json { render json: @users, status: :ok }
    end
  end

  def show
    @guild = Guild.find(params[:id])
    render json: Guild.clean(@guild)
  end

  def create
    puts "creating guild!"
    g_params = guild_params()
    if (!g_params)
      return false
    end

    @guild = @current_user.create_guild(guild_params)
    @current_user.guild_owner = true
    @current_user.guild_officer = true
    @current_user.guild_validated = true
    if @current_user.save and @guild
      respond_to do |format|
        format.html { redirect_to "/#guilds", notice: 'Guild was successfully added.' }
        format.json { render json: {alert: "Added guild"}, status: :ok }
      end
    else
      res_with_error("Failed to create new guild", :unauthorized)
    end
  end

  # PATCH/PUT /guilds/1
  # PATCH/PUT /guilds/1.json
  def update
    unless @current_user.guild.owner == @current_user
      res_with_error("You need to own the guild to edit it", :unauthorized)
      return false
    end

    g_params = guild_params
    if !g_params
      return false
    end

    respond_to do |format|
      if @guild.update(g_params)
        format.html { redirect_to "/#guilds", notice: 'Guild was successfully updated.' }
        format.json { head :no_content }
      else
        res_with_error("Guild was not updated.", :bad_request)
      end
    end
  end

  # DELETE /guilds/1
  # DELETE /guilds/1.json
  def destroy
    if @guild.active_war
      res_with_error("You can't destroy the guild while in a war!", :bad_request)
      return
    end
    unless @guild.owner == @current_user
      res_with_error("You can't destroy it if you don't own it!", :unauthorized)
      return
    end
    @guild.war_invites.each do |war|
      war.destroy
    end
    # remove all associations with this guild
    User.where("guild_id = #{@guild.id}").each do |user|
      User.reset_guild(user)
    end
    @guild.destroy
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'Guild was successfully quit.' }
      format.json { head :no_content }
    end
  end

  def remove
    @user = User.find(params[:id])
    if !@current_user.guild_owner && @user != @current_user
      res_with_error("You can't remove it if you don't own it!", :unauthorized)
      return
    end
    if @current_user.guild_owner && @user == @current_user
      @guild = @current_user.guild
      destroy
      return true
    end
    User.reset_guild(@user)
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'You quitted your guild' }
      format.json { render json: User.clean(@user), status: :ok }
    end
  end

  def invite
    @guild = Guild.find(@current_user.guild_id)
    @user = User.find(params[:id])
    @user.guild_id = @guild.id
    @user.guild_officer = false
    @user.guild_owner = false
    @user.guild_validated = false
    @user.save
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'Joining request sent.' }
      format.json { render json: User.clean(@current_user), status: :ok }
    end
  end

  def accept_invite
    @current_user.guild_validated = true
    @current_user.save
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'Joining request accepted.' }
      format.json { render json: {msg: "Joining request accepted"}, status: :ok }
    end
  end

  def reject_invite
    User.reset_guild(@current_user)
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'Joining request rejected.' }
      format.json { render json: {msg: "Joining request rejected"}, status: :ok }
    end
  end

  def set_officer
    @user = User.find_by(id: params[:id])
    @user.guild_officer = true
    @user.guild_owner = true #TODO Maybe an officer shouldn't be an owner by default?

    if @user.save
      respond_to do |format|
        format.html { redirect_to "/#guilds", notice: 'User set to officer' }
        format.json { render json: {msg: "User set to officer"}, status: :ok }
      end
    else
      res_with_error("Failed to set new user state", :unauthorized)
    end
  end

  def unset_officer
    @user = User.find_by(id: params[:id])
    @user.guild_officer = false
    @user.guild_owner = false

    if @user.save
      respond_to do |format|
        format.html { redirect_to "/#guilds", notice: 'User set to officer' }
        format.json { render json: {msg: "User set to normal"}, status: :ok }
      end
    else
      res_with_error("Failed to set new user state", :unauthorized)
    end
  end

  def add_points
    @guild.points += params[:points]
    if @guild.save
      respond_to do |format|
        format.html { redirect_to "/#guilds", notice: 'Guild points updated' }
        format.json { render json: {msg: "Guild points updated"}, status: :ok }
      end
    else
      res_with_error("Failed to add points", :bad_request)
    end
  end

  def update_officer_status
    return render json: { error: "Error. Only server owners/admins are allowed to assign/remove officers of any guild" }, status: :unauthorized unless @current_user&.owner or @current_user&.admin
    guild = Guild.find(params[:guild_id]) rescue nil
    action = params[:update_action]
    STDERR.puts "params is #{params}, guidld_id is #{params[:guild_id]} guild is #{guild}, action is #{action}"
    return render json: { error: "Error. Can't find the guild you're trying to change officers of." }, status: :bad_request unless guild
    target_user = guild.users.find_by(name: params[:targetuser_name])
    return render json: { error: "Error. Target user has to be a member of the #{guild.name} guild" }, status: :bad_request unless target_user
    return render json: { error: "Error. Can't change permissions of guild owner." }, status: :bad_request if guild.owner == target_user
    if action == "remove_officer"
      return render json: { error: "Error. Can't strip #{target_user.name} of officer role if he doesnt have it." }, status: :bad_request unless guild.officers.find_by(id: target_user)
      target_user.guild_officer = false
      target_user.save
      render json: { alert: "Succesfully stripped #{target_user.name} of officer role!" }, status: :ok
    elsif action == "give_officer"
      return render json: { error: "Error. Can't give #{target_user.name} the  officer role since they already are an officer." }, status: :bad_request if action == "give_officer" and guild.officers.find_by(id: target_user)
      target_user.guild_officer = true
      target_user.save
      render json: { alert: "Succesfully given #{target_user.name} an officer role!" }, status: :ok
    end
  end

  private

  def guild_params
    guild_params = params.require(:guild).permit(:id, :name, :anagram)
    if !guild_params['name'] || check_len(guild_params['name'], 3, 20)
      res_with_error("Name length must be >= 3 and <= 20", :bad_request)
      return false
    end
    if !guild_params['anagram'] || check_len(guild_params['anagram'], 2, 5)
      res_with_error("Anagram length must be >= 2 and <= 5", :bad_request)
      return false
    end
    (guild_params)
  end

  def set_guild
    @guild = Guild.find(params[:id])
  end

  def check_len(str, minlen, maxlen)
    if str && str.length >= minlen && str.length <= maxlen
      return false # no errors
    end
    true # error
  end

  def res_with_error(msg, error)
    respond_to do |format|
      format.html { redirect_to "/#guilds", alert: "#{msg}" }
      format.json { render json: {alert: "#{msg}"}, status: error }
    end
  end

  def connect_user
    User.all.each do |usr|
      if cookies[:log_token] == decrypt(usr.log_token)
        @current_user = usr
      end
    end
  end

  def has_guild
    if @current_user.guild
      res_with_error("You already are in a guild", :bad_request)
      return false
    end
  end

end
