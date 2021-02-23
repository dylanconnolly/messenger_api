require 'rails_helper'

RSpec.describe Message, type: :model do
    describe 'validations' do
        it { should validate_presence_of :user }
        it { should validate_presence_of :conversation }
        it { should validate_presence_of :content }
    end

    describe 'relationships' do
        it { should belong_to :user }
        it { should belong_to :conversation }
    end

    describe 'methods' do
        before :each do
            user1 = User.create(name: "User1")
            user2 = User.create(name: "User2")

            convo1 = Conversation.create
            convo1.users.push(user1, user2)

            120.times do
                Message.create(user: user1, conversation: convo1, content: "Message sent", created_at: (Time.zone.now - 5.day))
            end

            20.times do
                Message.create(user: user1, conversation: convo1, content: "Message sent")
            end
        end

        describe "get_recent_messages" do
            it "should return 100 most recent messages if a days_ago parameter is not provided" do

                response = Message.get_recent_messages

                expect(response.length).to eq(100)
            end

            it "should return all messages in given timeframe if days_ago parameter is provided" do

                response = Message.get_recent_messages("5")

                expect(response.length).to eq(140)
            end

            it "should return only messages from within a given timeframe" do

                response = Message.get_recent_messages("3")

                expect(response.length).to eq(20)
            end
        end
    end
end