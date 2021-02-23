class Api::V1::MessagesReceivedFromUserController < ApplicationController

    def index
        conversation = Conversation.find_conversation(params[:sender_id], params[:recipient_id])
        
        if conversation
            messages = conversation.get_recent_messages(params[:sender_id], query_params[:days_ago])

            render json: MessageSerializer.new(messages), status: 200
        else
            render json: {"error": "No conversation exists between the two provided user IDs."}, status: 404
        end
    end

    private
    
    def query_params
        params.permit(:days_ago)
    end
end