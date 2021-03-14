class Guild < ApplicationRecord
  has_many :users, -> { where(guild_validated: true) }, class_name: "User"
  has_many :requests, -> { where(guild_validated: false) }, class_name: "User"
  has_one :owner, -> { where(guild_owner: true) }, class_name: "User"
  has_many :officers, -> { where(guild_officer: true) }, class_name: "User"

  has_many :wars, class_name: "War", foreign_key: "guild1_id"
  has_one :active_war, -> { where(finished: false, accepted: true) }, class_name: "War", foreign_key: "guild1_id"
  has_many :finished_wars, -> { where(finished: true, accepted: true) }, class_name: "War", foreign_key: "guild1_id"
  has_many :war_invites, -> { where(finished: false, accepted: false) }, class_name: "War", foreign_key: "guild2_id" # invites from other guilds

  validates :name, uniqueness: true
  validates :anagram, uniqueness: true

  def self.clean(gld)
    new_gld = {
      id: gld.id,
      name: gld.name,
      anagram: gld.anagram,
      points: gld.points,
      max_battle_invites: gld.max_battle_invites,
      users: gld.users,
      requests: gld.requests,
      owner: gld.owner,
      officers: gld.officers,
      finished_wars: War.clean_arr(gld.finished_wars),
      war_invites: War.clean_arr(gld.war_invites)
    }
    if gld.active_war
      new_gld[:active_war] = War.clean(gld.active_war)
    end
    new_gld
  end


end
