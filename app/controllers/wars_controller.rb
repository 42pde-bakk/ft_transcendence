#noinspection RubyResolve
class WarsController < ApplicationController
  before_action :connect_user
  before_action :set_opponent_guild, only: [:create]
  before_action :check_active_war, only: [:create, :accept]

  def create
    if params[:prize].to_i > @current_user.guild.points or params[:prize].to_i > @opponent.points
      res_with_error("You or your opponent does not have enough points to commit to this war", :bad_request)
      return
    end
    if @current_user.guild_id == @opponent.id
      res_with_error("You cannot go to war with yourself", :bad_request)
      return
    end
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

  def accept_war
    # Check if not already in a war >> abort
    inverse_war = War.where(guild1_id: params[:id], guild2_id: @current_user.guild.id).first
    if inverse_war
      # Duplicate the inverse ware but with id's in reverse order and confirmed = true
      inverse_war.accepted = true
      inverse_war.save
      war = inverse_war.dup
      war.guild1_id = inverse_war.guild2_id
      war.guild2_id = inverse_war.guild1_id
      war.save
      g1 = Guild.find_by(id: war.guild1_id)
      g2 = Guild.find_by(id: war.guild2_id)
      g1.update_attribute(:max_unanswered_match_calls, war.max_unanswered_match_calls) if g1
      g2.update_attribute(:max_unanswered_match_calls, war.max_unanswered_match_calls) if g2
    else
      res_with_error("Somehow, the war you want to accept does not exist", :bad_request)
      return
    end
    CheckIfWarEndedJob.set(wait_until: inverse_war.end).perform_later(inverse_war.id)
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'War request sent.' }
      format.json { render json: { msg: "War request accepted" }, status: :ok }
    end
  end

  def reject_war
    inverse_war = War.where(guild1_id: params[:id], guild2_id: @current_user.guild.id).first
    unless inverse_war
      res_with_error("Somehow, the war you want to accept does not exist", :bad_request)
      return false
    end
    inverse_war.destroy
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'War request sent.' }
      format.json { render json: { msg: "War request rejected" }, status: :ok }
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
                                :max_unanswered_match_calls,
                                :ladder,
                                :tournament,
                                :duel,
                                :extra_speed,
                                :long_paddles)
  end

  def set_opponent_guild
    @opponent_guild_id = params[:guild2_id]
    @opponent = Guild.where(id: @opponent_guild_id).first
    if @opponent_guild_id == @current_user.guild.id.to_s
      res_with_error("You can't go to war with yourself", :bad_request)
      false
    end
    unless @opponent
      res_with_error("Opponent is missing", :bad_request)
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
      if cookies[:log_token] == decrypt(usr.log_token)
        @current_user = usr
      end
    end
  end
end
