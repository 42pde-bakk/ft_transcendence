#noinspection RubyResolve
class BattlesController < ApplicationController
  before_action :connect_user
  before_action :set_opponent, only: [:create]
  before_action :check_active_battle, only: [:create, :accept_battle]
  before_action :check_response_time, only: [:reject_battle, :accept_battle]

  def create
    inverse_battle = Battle.where(user1_id: @current_user.id, user2_id: @opponent.id).first
    if inverse_battle
      res_with_error("Already sent and invite to this user.", :bad_request)
      return
    else
      @current_user.battles.create(user1_id: @current_user.id,
                                   user2_id: @opponent.id,
                                   time_to_accept: params[:time_to_accept])
    end
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'Battle request sent.' }
      format.json { render json: { msg: "Battle request sent" }, status: :ok }
    end
  end

  def accept_battle
    inverse_battle = Battle.where(user1_id: params[:user2_id], user2_id: @current_user.id).first
    if inverse_battle
      # Duplicate the inverse ware but with id's in reverse order and confirmed = true
      inverse_battle.accepted = true
      inverse_battle.save
      battle = inverse_battle.dup
      battle.user1_id = inverse_battle.user2_id
      battle.user2_id = inverse_battle.user1_id
      battle.save
    else
      res_with_error("Somehow, the battle you want to accept does not exist", :bad_request)
      return
    end
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'Battle accepted' }
      format.json { render json: { msg: "Battle accepted" }, status: :ok }
    end
  end

  def reject_battle
    inverse_battle = Battle.where(user1_id: params[:user2_id], user2_id: @current_user.id).first
    unless inverse_battle
      res_with_error("Somehow, the battle you want to reject does not exist", :bad_request)
      return false
    end
    inverse_battle.destroy
    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'Battle rejected' }
      format.json { render json: { msg: "Battle rejected" }, status: :ok }
    end
  end


  def resolve_battle
    winner_id = params[:winner_id]
    loser_id = params[:loser_id]
    battle = Battle.where(user1_id: winner_id, user2_id: loser_id).first
    inverse_battle = Battle.where(user1_id: loser_id, user2_id: winner_id).first
    battle.user1.guild.active_war.g1_points += 1
    battle.user1.guild.active_war.save
    battle.user2.guild.active_war.g2_points += 1
    battle.user2.guild.active_war.save
    battle.finished = true
    battle.save
    inverse_battle.finished = true
    inverse_battle.save

    respond_to do |format|
      format.html { redirect_to "/#guilds", notice: 'Battle resolved' }
      format.json { render json: { msg: "Battle resolved" }, status: :ok }
    end
  end

  private

  def handle_points(winner_id)
    battle = Battle.where(user1_id: winner_id, user2_id: @current_user.id).first
    battle.user1.guild.active_war.g1_points += 1
    battle.user1.guild.active_war.save
    if battle.user2.guild.active_war
      battle.user2.guild.active_war.g2_points += 1
      battle.user2.guild.active_war.save
    end
  end

  def check_response_time
    battle = Battle.where(user1_id: params[:user2_id], user2_id: @current_user.id).first
    if battle
      minutes_passed = (Time.now - battle.created_at)/60
      if minutes_passed > battle.time_to_accept
        handle_points(battle.user1_id) # win because we are dealing with the battle from the guild that send the req
        battle.destroy
        res_with_error("You did not respond in time, so you lost the battle.", :bad_request)
      end
    end
  end

  def set_opponent
    @opponent_id = params[:user2_id]
    @opponent = User.where(id: @opponent_id).first
    if @opponent_id == @current_user.id.to_s
      res_with_error("You can't battle with yourself", :bad_request)
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

  def check_active_battle
    if @current_user.active_battle
      res_with_error("You cannot accept two battles at the same time", :bad_request)
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
