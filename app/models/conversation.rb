class Conversation < ApplicationRecord
    has_many :user_conversations
    has_many :users, through: :user_conversations
    has_many :messages

    validates_length_of :users, maximum: 2
    
    def self.find_or_create_conversation(sender, recipient)
        
        response = find_conversation(sender.id, recipient.id)
        
        return response if response
        
        conversation = Conversation.create
        conversation.users.push(sender, recipient)
        return conversation
    end
    
    def self.find_conversation(sender_id, recipient_id)
        joins(:user_conversations).
        group(:id).
        where("user_id IN (#{sender_id}, #{recipient_id})").
        having("COUNT(*) = 2")[0]
    end

    def get_recent_messages(user_id, days_ago = nil)
        if (!days_ago)
            messages.where(user: user_id).limit(100).order('created_at DESC')
        else
            number_of_days = days_ago.to_i > 30 ? 30 : days_ago.to_i
            
            messages.where("user_id = #{user_id} AND created_at > '#{timestamp_days_ago(number_of_days)}'").
            order('created_at DESC')
        end
    end

    private

    def timestamp_days_ago(number_of_days_ago)
        Time.zone.now.change(hour: 0) - number_of_days_ago.day
    end
end