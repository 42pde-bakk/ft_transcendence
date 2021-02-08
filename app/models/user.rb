class User < ApplicationRecord
  # friends relation setup
  has_many :friendships
  has_many :confirmed_friendships, -> { where confirmed: true }, class_name: 'Friendship'
  has_many :friends, :through => :confirmed_friendships, class_name: 'User', :source => :friend
  has_many :invitations, -> { where confirmed: false }, class_name: 'Friendship', foreign_key: "friend_id"
  # get the users that sent me a friend request
  has_many :invites, :through => :invitations, class_name: 'User', :source => :user

  validates :name, uniqueness: true
  validates :token, uniqueness: true

  def self.clean(usr)
    new_user = {
      id: usr.id,
      name: usr.name,
      img_path: usr.img_path,
      token: usr.token,
      guild_id: usr.guild_id,
      tfa: usr.tfa,
      reg_done: usr.reg_done,
      current: usr.current,
      friends: usr.friends,
      invites: usr.invites
    }
  end

end
