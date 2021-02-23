require 'rails_helper'

describe 'when a POST request is made with a request body containing existing users and a message' do
    it "a new message should be created and added to the conversation between the two users" do
        user1 = User.create(name: "User1")
        user2 = User.create(name: "User2")
        
        request = {
            sender: "User1",
            recipient: "User2",
            content: "Hi there, User2"
        }

        post '/api/v1/messages', params: request

        expect(response).to be_successful

        parsed = JSON.parse(response.body, symbolize_name: true)

        expect(parsed).to eq({"ahdad": "akdha"})
    end
end