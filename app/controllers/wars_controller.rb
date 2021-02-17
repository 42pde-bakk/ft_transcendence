#noinspection RubyResolve
class WarsController < ApplicationController
  before_action :connect_user
  before_action :set_opponent_guild
  before_action :check_active_war, only: [:create, :accept]

  def create
    inverse_war = War.where(guild1_id: @current_user.guild.id, guild2_id: @opponent.id).first
    if inverse_war && !check_active_war
      @current_user.wars.create(guild2: @opponent, confirmed: true)
      inverse_war.confirmed = true
      inverse_war.save
    else
      @current_user.guild.wars.create(war_params)
    end
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'War request sent.' }
      format.json { render json: { msg: "War request sent" }, status: :ok }
    end
  end

  private

  def war_params
    params.require(:war).permit(:guild1_id,
                                :guild2_id,
                                :start,
                                :end,
                                :prize,
                                :wt_begin,
                                :wt_end,
                                :time_to_answer,
                                :ladder,
                                :tournament,
                                :duel)
  end

  def set_opponent_guild
    @opponent_guild_id = params[:guild2_id]
    @opponent = Guild.where(id: @opponent_guild_id).first
    if @opponent_guild_id == @current_user.guild.id.to_s
      res_with_error("You can't go to war with yourself", :bad_request)
      false
    end
  end

  def res_with_error(msg, error)
    respond_to do |format|
      format.html { redirect_to "/", alert: "#{msg}" }
      format.json { render json: { alert: "#{msg}" }, status: error }
    end
  end

  def check_active_war
    if @current_user.guild.active_war
      res_with_error("You cannot accept a war when you are already at war", :bad_request)
      return false
    end
    true
  end

  def connect_user
    User.all.each do |usr|
      if cookies[:log_token] == usr.log_token
        @current_user = usr
      end
    end
  end
end
