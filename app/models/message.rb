class Message < ApplicationRecord
    validates_presence_of :user
    validates_presence_of :conversation
    validates_presence_of :content

    belongs_to :user
    belongs_to :conversation

end