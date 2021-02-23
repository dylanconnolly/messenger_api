class Api::V1::MessagesController < ApplicationController

    def create
        sender = User.find(message_params[:sender_id])
        recipient = User.find(message_params[:recipient_id])

        conversation = Conversation.find_or_create_conversation(sender, recipient)
        
        message = Message.new(user: sender, conversation: conversation, content: message_params[:content])

        if message.save
            render json: MessageSerializer.new(message), status: 201
        else
            render json: {success: 'false', error: 'Error creating message'}, status: 401
        end
    end

    def index
        messages = Message.get_recent_messages(message_params[:days_ago])

        render json: MessageSerializer.new(messages), status: 200
    end

    private

    def message_params
        params.permit(:sender_id, :recipient_id, :content, :days_ago)
    end
end