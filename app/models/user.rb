class User < ActiveRecord::Base
  has_secure_password
  # attr_accessible :username, :password_digest
  validates :username, uniqueness: true
  validates :username, :password, presence: true
  ### Uncomment associations as they are created
  has_many :additions
  has_many :games, through: :additions
  has_many :votes
  has_many :voted_games, through: :votes, class_name: "Game"

  has_many :received_relationships, class_name: "Relationship", foreign_key: :receiver_id
  has_many :sent_relationships, class_name: "Relationship", foreign_key: :sender_id

  has_many :requested_friends, through: :sent_relationships, source: :receiver
  has_many :friend_requests, through: :received_relationships, source: :sender

  def friends
    friends = []
    Relationship.where(sender: self, status: true).each do |rel|
      friends << rel.receiver
    end
    Relationship.where(receiver: self, status: true).each do |rel|
      friends << rel.sender
    end
    friends
    # friends = self.requested_friends + self.friend_requests
    # friends.uniq!
  end

  def pending_friends
    friends = []
    self.sent_relationships.where(status: false).each do |rel|
      friends << rel.receiver
    end
    self.received_relationships.where(status: false).each do |rel|
      friends << rel.sender
    end
    friends
  end

  def sent_requests
    requests = []
    Relationship.where(receiver: self).find_each do |rel|
      requests << rel.sender
    end
    requests
  end

  # def self.send_request(user1, user2)#user_id
  #   validate = user1.is_friend?(user2)
  #   if validate == false
  #     new_relationship = Relationship.new(sender: user1, receiver: user2, status: false)
  #     return new_relationship.save
  #   end
  # end

  def request(sender)
    Relationship.where(sender: sender, receiver: self, status: false)
  end

  def is_friend?(user)
    Relationship.where(sender: self, status: true).find_each do |rel|
      return true if rel.receiver === user
    end
    false
  end

  # def games
  #   Game.all
  # end
end
