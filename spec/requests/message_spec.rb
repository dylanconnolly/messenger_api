require 'rails_helper'

describe 'when a POST request is made with a request body containing existing users and a message' do
    it "a new message should be created and added to the conversation between the two users" do
        user1 = User.create(name: "User1")
        user2 = User.create(name: "User2")
        
        request = {
            sender_id: user1.id,
            recipient_id: user2.id,
            content: "Hi there, User2"
        }

        post '/api/v1/messages', params: request

        expect(response).to be_successful

        parsed = JSON.parse(response.body)

        # expect(parsed).to eq({"ahdad": "akdha"})
    end

    # it "should return a 404 error if a sender or recipient name is does not exist as a user" do
    #     user1 = User.create(name: "User1")
    #     user2 = User.create(name: "User2")

    #     request = {
    #         sender: "User1",
    #         recipient: "Fake User",
    #         content: "Hi there user that does not exist."
    #     }

    #     post '/api/v1/messages', params: request

    #     expect(response).to_not be_successful

    #     parsed = JSON.parse(response.body)
    # end
end

describe "when a GET request is made to /messages" do
    before :each do
        user1 = User.create(name: "User1")
        user2 = User.create(name: "User2")
        user3 = User.create(name: "User3")

        convo1 = Conversation.create
        convo1.users.push(user1, user2)
        
        convo2 = Conversation.create
        convo2.users.push(user2, user3)

        15.times do
            Message.create(user: user1, conversation: convo1, content: "User 1 message in conversation 1")
        end

        10.times do
            Message.create(user: user2, conversation: convo1, content: "User 2 message in conversation 1")
        end

        5.times do
            Message.create(user: user2, conversation: convo2, content: "User 2 message in conversation 2")
        end

        10.times do
            Message.create(user: user3, conversation: convo2, content: "User 3 message in conversation 2")
        end
    end

    it "an index of all messages should be returned" do
        
        get '/api/v1/messages'

        expect(response).to be_successful

        parsed = JSON.parse(response.body)
        
        expect(parsed["data"].length).to eq(40)
    end
end