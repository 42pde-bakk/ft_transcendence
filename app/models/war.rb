class War < ApplicationRecord
  belongs_to :guild1, class_name: "Guild"
  belongs_to :guild2, class_name: "Guild"

  def self.clean(war)
    new_war = {
      id: war.id,
      guild1_id: war.guild1_id,
      guild2_id: war.guild2_id,
      opponent_name: war.guild2.name,
      invite_name: war.guild1.name,
      finished: war.finished,
      accepted: war.accepted,
      start: war.start,
      end: war.end,
      prize: war.prize,
      g1_points: war.g1_points,
      g2_points: war.g2_points,
      wt_begin: war.wt_begin,
      wt_end: war.wt_end,
      time_to_answer: war.time_to_answer,
      ladder: war.ladder,
      tournament: war.tournament,
      duel: war.duel,
      winning_guild_id: war.winning_guild_id
    }

    if war.g1_points == war.g2_points
      new_war[:result] = "Equal"
    elsif war.g1_points > war.g2_points
      new_war[:result] = "Won"
    else
      new_war[:result] = "Lost"
    end

    if war.start <= Date.current && war.end >= Date.current
      new_war[:active] = true
    else
      new_war[:active] = false
    end

    if war.wt_begin.strftime("%H:%M:%S") <= Time.now.strftime("%H:%M:%S") && war.wt_end.strftime("%H:%M:%S") >= Time.now.strftime("%H:%M:%S")
      new_war[:wt_active] = true
    else
      new_war[:wt_active] = false
    end
    new_war
  end

  def self.clean_arr(war_arr)
    new_war_arr = []

    war_arr.each do |war|
      new_war_arr.append clean(war)
    end
    new_war_arr
  end

  def add_war_points(to_guild_id)
    if to_guild_id == guild1_id
      self.g1_points += 1
    elsif to_guild_id == guild2_id
      self.g2_points += 1
    end
    self.save!
  end
end
