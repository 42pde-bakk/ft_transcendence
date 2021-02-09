class GuildsController < ApplicationController
  before_action :connect_user

  def index
    @guilds = Guild.all
    render json: @guilds
  end

  def create
    @guild = @current_user.create_guild(guild_params)
    @current_user.guild_owner = true
    @current_user.guild_validated = true
    if @current_user.save and @guild
      respond_to do |format|
        format.html { redirect_to @guild, notice: 'Guild was successfully created.' }
        format.json { render json: {alert: "Added guild"}, status: :ok }
      end
    else
      res_with_error("error creating guild", :unprocessable_entity)
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
