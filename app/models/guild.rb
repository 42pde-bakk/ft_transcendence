class Guild < ApplicationRecord
  has_many :users, -> { where(guild_validated: true) }, class_name: "User"
  has_many :requests, -> { where(guild_validated: false) }, class_name: "User"
  has_one :owner, -> { where(guild_owner: true) }, class_name: "User"
  has_many :officers, -> { where(guild_officer: true) }, class_name: "User"

  validates :name, uniqueness: true
  validates :anagram, uniqueness: true

  def self.clean(gld)
    new_user = {
      id: gld.id,
      name: gld.name,
      anagram: gld.anagram,
      points: gld.points,
      users: gld.users,
      requests: gld.requests,
      owner: gld.owner,
      officers: gld.officers
    }
  end


end
