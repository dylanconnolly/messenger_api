class User < ApplicationRecord
    has_many :user_conversations
    has_many :conversations, through: :user_conversations
    has_many :messages

    validates_presence_of :name

end