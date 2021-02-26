#noinspection RubyResolve
def encrypt(log_token)
  return ((log_token.to_i + 420 - 69).to_s)
end
def decrypt(log_token)
  return ((log_token.to_i - 420 + 69).to_s)
end

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
    else
      res_with_error("Somehow, the war you want to accept does not exist", :bad_request)
      return
    end
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

  def resolve_war(winner_id)
    if winner_id == @current_user.guild_id.to_s
      war = War.where(guild1_id: @current_user.guild_id, guild2_id: winner_id).first
      inverse_war = War.where(guild1_id: winner_id, guild2_id: @current_user.guild_id).first
    else
      war = War.where(guild1_id: winner_id, guild2_id: @current_user.guild_id).first
      inverse_war = War.where(guild1_id: @current_user.guild_id, user2_id: winner_id).first
    end
    handle_points(war.guild1_id)
    war.finished = true
    inverse_war.finished = true
    war.save
    inverse_war.save
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'War resolved' }
      format.json { render json: { msg: "War resolved" }, status: :ok }
    end
  end

  def handle_points(winner_id)
    war = War.where(guild1_id: winner_id, guild_id: @current_user.guild_id).first
    war.guild1.points += war.prize
    war.guild1.save
    war.guild2.points -= war.prize
    war.guild2.save
  end

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
