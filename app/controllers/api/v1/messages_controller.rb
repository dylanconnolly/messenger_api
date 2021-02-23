class Api::V1::MessagesController < ApplicationController

    def create
        sender = User.find_by(name: message_params[:sender])
        recipient = User.find_by(name: message_params[:recipient])

        conversation = Conversation.find_or_create_conversation(sender, recipient)
        
        message = Message.new(user: sender, conversation: conversation, content: message_params[:content])

        if message.save
            p 'success'
        else
        require 'pry'; binding.pry
    end

    private

    def message_params
        params.permit(:sender, :recipient, :content)
    end
end