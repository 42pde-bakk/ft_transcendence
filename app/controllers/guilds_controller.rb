class GuildsController < ApplicationController
  before_action :connect_user

  def index
    @guilds = Guild.all
    render json: @guilds
  end

  def show
    @guild = Guild.find(params[:id])
    render json: Guild.clean(@guild)
  end

  def create
    @guild = @current_user.create_guild(guild_params)
    @current_user.guild_owner = true
    @current_user.guild_validated = true
    if @current_user.save and @guild
      render json: {alert: "Added guild"}, status: :ok
    else
      render json: {alert: "There was an error saving your changes"}, status: :unprocessable_entity
    end
  end

  # DELETE /guilds/1
  # DELETE /guilds/1.json
  def destroy
    unless @guild.owner == @current_user
      res_with_error("You can't destroy it if you don't own it!", :unauthorized)
      return
    end
    # remove all associations with this guild
    User.where("guild_id = #{@guild.id}").each do |user|
      User.reset_guild(user)
    end
    @guild.destroy
    respond_to do |format|
      format.html { redirect_to guilds_url, notice: 'Guild was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def quit
    if @current_user.guild_owner
      @guild = @current_user.guild
      destroy
      return true
    end
    User.reset_guild(current_user)
    respond_to do |format|
      format.html { redirect_to guilds_url, notice: 'You quitted your guild' }
      format.json { render json: User.clean(current_user), status: :ok }
    end
  end


  private

  def guild_params
    guild_params = params.require(:guild).permit(:name, :anagram)
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

  def check_len(str, minlen, maxlen)
    if str && str.length >= minlen && str.length <= maxlen
      return false # no errors
    end
    true # error
  end

  def res_with_error(msg, error)
    respond_to do |format|
      format.html { redirect_to "/", alert: "#{msg}" }
      format.json { render json: {alert: "#{msg}"}, status: error }
    end
  end

  def connect_user
    User.all.each do |usr|
      if cookies[:atoken] == usr.token
        @current_user = usr
      end
    end
  end

end
