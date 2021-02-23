class Api::V1::MessagesBetweenUsersController < ApplicationController

    def index
        sender = User.find_by(name: params[:sender])
        recipient = User.find_by(name: params[:recipient])

        conversation = Conversation.find_conversation(sender.id, recipient.id)

        messages = conversation.messages.where(user: sender)

        render json: MessageSerializer.new(messages), status: 200
        # require 'pry'; binding.pry
    end
end