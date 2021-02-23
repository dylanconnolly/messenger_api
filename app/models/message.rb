class Message < ApplicationRecord
    validates_presence_of :user
    validates_presence_of :conversation
    validates_presence_of :content

    belongs_to :user
    belongs_to :conversation

    def self.get_recent_messages(days_ago = nil)
        if (!days_ago)
            all.limit(100)
        else
            number_of_days = days_ago.to_i > 30 ? 30 : days_ago.to_i
            
            where("created_at > '#{timestamp_days_ago(number_of_days)}'")
        end
    end

    private

    def self.timestamp_days_ago(number_of_days_ago)
        Time.zone.now.change(hour: 0) - number_of_days_ago.day
    end
end