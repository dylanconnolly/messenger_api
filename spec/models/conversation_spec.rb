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

        describe 'find_or_create_conversation' do
            it 'should find an existing conversation if one already exists between users' do
                response = Conversation.find_or_create_conversation(@user1, @user2)

                expect(response).to eq(@convo1)
            end

            it 'should create a new conversation if one does not already exist between users' do
                response = Conversation.find_or_create_conversation(@user1, @user4)

                expect(Conversation.count).to eq(5)
                expect(@user1.conversations).to eq([@convo1, @convo2, response])
                expect(Conversation.last.users).to eq([@user1, @user4])
            end
        end

        describe "get_recent_messages" do
            it "should take a number as string and get all messages in a conversation from that many days ago or newer" do
                message1 = Message.create(user: @user1, conversation: @convo1, content: "Message sent today")

                message2 = Message.create(user: @user1, conversation: @convo1, content: "Message sent a week ago", created_at: "Tue, 16 Feb 2021 15:17:38 UTC +00:00")

                response = @convo1.get_recent_messages(@user1.id, "3")
                response2 = @convo1.get_recent_messages(@user1.id)

                expect(response).to eq([message1])
                expect(response2).to eq([message1, message2])
            end

            it "should retrieve ALL messages in timeframe provided by days_ago parameter (not limited to 100)" do
                110.times do
                    Message.create(user: @user1, conversation: @convo1, content: "Message sent today")
                end
                
                response = @convo1.get_recent_messages(@user1.id, "20")

                expect(response.length).to eq(110)
            end
        end
    end
end