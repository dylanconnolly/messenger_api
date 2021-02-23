require 'rails_helper'

RSpec.describe 'when a GET request is made to /messages/recipient/sender' do
    before :each do
        @user1 = User.create(name: "User1")
        @user2 = User.create(name: "User2")
        @user3 = User.create(name: "User3")

        @conversation = Conversation.create
        conversation2 = Conversation.create
        
        @conversation.users.push(@user1, @user2)
        conversation2.users.push(@user1, @user3)

        Message.create(user: @user1, conversation: @conversation, content: "First message", created_at: (Time.zone.now - 4.day))
        Message.create(user: @user2, conversation: @conversation, content: "User 2 response", created_at: (Time.zone.now - 3.day))
        Message.create(user: @user1, conversation: @conversation, content: "User 1 message", created_at: (Time.zone.now - 3.day))
        Message.create(user: @user1, conversation: @conversation, content: "User 1 message again", created_at: (Time.zone.now - 1.day))
        Message.create(user: @user2, conversation: @conversation, content: "User 2 message")
        
    end

    it 'a list of messages from that sender will be returned' do

        get "/api/v1/messages/#{@user2.id}/#{@user1.id}"

        expect(response).to be_successful
        
        parsed = JSON.parse(response.body)
        
        expect(parsed["data"].length).to eq(3)
        expect(parsed["data"][0]["attributes"]["content"]).to eq("User 1 message again")
        expect(parsed["data"][-1]["attributes"]["content"]).to eq("First message")
    end

    it "an empty object will be returned if no messages exist" do
        
        get "/api/v1/messages/#{@user1.id}/#{@user3.id}"
        
        expect(response).to be_successful

        parsed = JSON.parse(response.body)

        expect(parsed["data"]).to eq([])
    end

    it "an optional query param of days_ago can be provided to only return messages from that many days ago" do

        Message.create(user: @user2, conversation: @conversation, content: "Sent 7 days ago", created_at: "Tues, 16 Feb 2021 15:17:38 GMT")

        get "/api/v1/messages/#{@user1.id}/#{@user2.id}?days_ago=3"

        expect(response).to be_successful
        
        parsed = JSON.parse(response.body)

        expect(parsed["data"].length).to eq(2)
    end

    it "if days_ago provided is larger than 30 it will default to 30 days" do
        Message.create(user: @user2, conversation: @conversation, content: "Sent 40 days ago", created_at: (Time.zone.now - 40.day))

        get "/api/v1/messages/#{@user1.id}/#{@user2.id}?days_ago=50"

        expect(response).to be_successful
        
        parsed = JSON.parse(response.body)

        expect(parsed["data"].length).to eq(2)
    end

    it "if a conversation does not exist for given sender and recipient, message should be returned stating no messages exist with 404" do

        get "/api/v1/messages/#{@user2.id}/#{@user3.id}"

        expect(response).to_not be_successful
        expect(response.status).to eq(404)

        parsed = JSON.parse(response.body)
        
        expect(parsed["error"]).to eq("No conversation exists between the two provided user IDs.")
    end
end