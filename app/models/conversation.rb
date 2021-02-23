class Conversation < ApplicationRecord
    has_many :user_conversations
    has_many :users, through: :user_conversations
    has_many :messages

    
    def self.find_or_create_conversation(sender, recipient)
        
        response = find_conversation(sender.id, recipient.id)
        
        return response if response
        
        conversation = Conversation.create
        conversation.users.push(sender, recipient)
        return conversation
    end

    private

    def self.find_conversation(sender_id, recipient_id)
        joins(:user_conversations).
        group(:id).
        where("user_id IN (#{sender_id}, #{recipient_id})").
        having("COUNT(*) = 2")[0]
    end
end