require 'rails_helper'

RSpec.describe Conversation, type: :model do
    describe 'relationships' do
        it { should have_many :user_conversations }
        it { should have_many(:users).through(:user_conversations) }
        it { should have_many :messages }
    end

    describe 'methods' do
        before :each do
            @user1 = User.create(name: "User1")
            @user2 = User.create(name: "User2")
            @user3 = User.create(name: "User3")
            @user4 = User.create(name: "User4")

            @convo1 = Conversation.create
            @convo1.users.push(@user1, @user2)

            @convo2 = Conversation.create
            @convo2.users.push(@user1, @user3)

            @convo3 = Conversation.create
            @convo3.users.push(@user2, @user3)

            @convo4 = Conversation.create
            @convo4.users.push(@user2, @user4)
        end

        describe 'find_conversation' do
            it 'should return the conversation between two user ids if one exists' do
                response = Conversation.find_conversation(@user1.id, @user2.id)
                response2 = Conversation.find_conversation(@user2.id, @user3.id)
                response3 = Conversation.find_conversation(@user1.id, @user3.id)
                response4 = Conversation.find_conversation(@user3.id, @user1.id)

                expect(response).to eq(@convo1)
                expect(response2).to eq(@convo3)
                expect(response3).to eq(@convo2)
                expect(response4).to eq(@convo2)
            end

            it 'should return nil if a conversation does not exist between two users' do
                response = Conversation.find_conversation(@user1.id, @user4.id)

                expect(response).to be(nil)
            end

            it 'should return nil if users do not exist' do
                response = Conversation.find_conversation(12345, 213981)

                expect(response).to be (nil)
            end
        end
    end
end