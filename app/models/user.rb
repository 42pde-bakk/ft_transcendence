class User < ApplicationRecord
  # friends relation setup
  has_many :friendships
  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: 'Friendship'
  has_many :friends, :through => :confirmed_friendships, class_name: 'User', :source => :friend
  has_many :invitations, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: "friend_id"
  # get the users that sent me a friend request
  has_many :invites, :through => :invitations, class_name: 'User', :source => :user
  has_many :blocked_users, class_name: "BlockedUser", dependent: :destroy
  has_many :messages, class_name: "Message", dependent: :destroy

  belongs_to :guild, required: false
  has_one :game, class_name: "Game", required: false
  # has_one :game, class_name: "Game", foreign_key: "player1_id"
  # has_one :game_invite, class_name: "Game", foreign_key: "player2_id"
  has_many :notifications, class_name: "Notification"

  has_many :battles, class_name: "Battle", foreign_key: "user1_id"
  has_one :active_battle, -> { where(finished: false, accepted: true) }, class_name: "Battle", foreign_key: "user1_id"
  has_many :finished_battles, -> { where(finished: true) }, class_name: "Battle", foreign_key: "user1_id"
  has_many :battle_invites, -> { where(finished: false, accepted: false) }, class_name: "Battle", foreign_key: "user2_id" # invites from other users

  validates :name, uniqueness: true
 # validates :token, uniqueness: true

  def self.clean(usr)
    new_user = {
      id: usr.id,
      elo: usr.elo,
      name: usr.name,
      email: usr.email,
      owner: usr.owner,
      admin: usr.admin,
      ban: usr.ban,
      img_path: usr.img_path,
      token: usr.token,
      guild_id: usr.guild_id,
      guild_owner: usr.guild_owner,
      guild_officer: usr.guild_officer,
      guild_validated: usr.guild_validated,
      log_token: usr.log_token,
      tfa: usr.tfa,
      reg_done: usr.reg_done,
      current: usr.current,
      friends: usr.friends,
      invites: usr.invites,
      last_seen: usr.last_seen,
      is_ingame: usr.is_ingame,
      is_queueing: usr.is_queueing
    }
    if usr.active_battle
      new_user[:active_battle] = Battle.clean(usr.active_battle)
    end
    if usr.guild_id
      new_user[:guild] = Guild.clean(usr.guild);
    end
    new_user
  end

  def self.reset_guild(usr)
    usr.guild_id = nil
    usr.guild_officer = false
    usr.guild_owner = false
    usr.guild_validated = false
    usr.save
  end

  def self.has_officer_rights(usr)
    return (usr.guild_owner || usr.guild_officer)
  end

end
