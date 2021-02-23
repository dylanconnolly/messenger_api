require 'rails_helper'

RSpec.describe 'when a GET request is made to /messages/recipient/sender' do
    before :each do
        @user1 = User.create(name: "User1")
        @user2 = User.create(name: "User2")

        conversation = Conversation.new

        conversation.users.push(@user1, @user2)

        Message.create(user: @user1, conversation: conversation, content: "First message")
        Message.create(user: @user2, conversation: conversation, content: "User 2 response")
        Message.create(user: @user1, conversation: conversation, content: "User 1 message")
        Message.create(user: @user1, conversation: conversation, content: "User 1 message again")
        Message.create(user: @user2, conversation: conversation, content: "User 2 message")
        
    end

    it 'a list of messages from that sender will be returned' do

        get "/api/v1/messages/#{@user2.name}/#{@user1.name}"

        expect(response).to be_successful
        
        parsed = JSON.parse(response.body)
        
        expect(parsed["data"].length).to eq(3)
        expect(parsed["data"][0]["attributes"]["content"]).to eq("First message")
        expect(parsed["data"][-1]["attributes"]["content"]).to eq("User 1 message again")
    end
end