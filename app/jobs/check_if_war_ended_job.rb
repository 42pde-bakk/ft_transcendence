class CheckIfWarEndedJob < ApplicationJob
  queue_as :default

  def resolve_war(winner_id, loser_id)
    war = War.where(guild1_id: winner_id, guild2_id: loser_id).first
    inverse_war = War.where(guild1_id: loser_id, guild2_id: winner_id).first
    handle_points(winner_id, loser_id)
    war.finished = true
    war.save
    inverse_war.finished = true
    inverse_war.save
  end

  def handle_points(winner_id, loser_id)
    war = War.where(guild1_id: winner_id, guild2_id: loser_id).first
    war.guild1.points += war.prize
    war.guild1.save
    war.guild2.points -= war.prize
    war.guild2.save
  end

  def perform(war_id)
    war = War.find_by(id: war_id)
    return unless war # Might have already been ended because of max unanswered match calls
    war.guild1.unanswered_match_calls = 0
    war.guild1.save
    war.guild2.unanswered_match_calls = 0
    war.guild2.save
    if war.end <= Time.now && war.finished == false
      if war.g1_points == war.g2_points
        inverse_war = War.where(guild1_id: war.guild2_id, guild2_id: war.guild1_id).first
        war.finished = true
        war.save
        inverse_war.finished = true
        inverse_war.save
      elsif war.g1_points > war.g2_points
        resolve_war(war.guild1_id, war.guild2_id)
      end
    end
  end
end
