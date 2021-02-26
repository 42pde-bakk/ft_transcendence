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

  def perform(*args)
    War.all.each do |war|
      puts "In first loop"
      if war.end < Time.now && war.finished == false
        puts "flag 2"
        if war.g1_points == war.g2_points
          puts "flag =="
          war.finished = true
          war.save
        elsif war.g1_points > war.g2_points
          puts "flag >"
          resolve_war(war.guild1_id, war.guild2_id)
        end
      end
    end
    CheckIfWarEndedJob.set(wait: 1.minute).perform_later
  end
end
