class Api::V1::MessagesController < ApplicationController

    def create
        sender = User.find_by(name: message_params[:sender])
        recipient = User.find_by(name: message_params[:recipient])

        conversation = Conversation.find_or_create_conversation(sender, recipient)
        
        message = Message.new(user: sender, conversation: conversation, content: message_params[:content])

        if message.save
            render json: MessageSerializer.new(message), status: 201
        else
            render json: {success: 'false', error: 'Error creating message'}, status: 401
        end
    end

    def index
        messages = Message.all.limit(100)

        render json: MessageSerializer.new(messages), status: 200
    end

    private

    def message_params
        params.permit(:sender, :recipient, :content)
    end
end