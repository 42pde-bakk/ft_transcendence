class War < ApplicationRecord
  belongs_to :guild1, class_name: "Guild"
  belongs_to :guild2, class_name: "Guild"

  def self.clean(war)
    new_war = {
      id: war.id,
      guild1_id: war.guild1_id,
      guild2_id: war.guild2_id,
      finished: war.finished,
      accepted: war.accepted,
      start: war.start,
      end: war.end,
      prize: war.prize,
      wt_begin: war.wt_begin,
      wt_end: war.wt_end,
      time_to_answer: war.time_to_answer,
      ladder: war.ladder,
      tournament: war.tournament,
      duel: war.duel,
      winning_guild_id: war.winning_guild_id
    }
  end
end
