class Battle < ApplicationRecord
  belongs_to :user1, class_name: "User"
  belongs_to :user2, class_name: "User"

  def self.clean(battle)
    new_battle = {
      id: battle.id,
      user1_id: battle.user1_id,
      user2_id: battle.user2_id,
      user1: battle.user1,
      user2: battle.user2,
      finished: battle.finished,
      accepted: battle.accepted,
      time_to_accept: battle.time_to_accept,
    }
  end

  def self.clean_arr(battle_arr)
    new_battle_arr = []

    battle_arr.each do |war|
      new_battle_arr.append clean(war)
    end
    new_battle_arr
  end
end
