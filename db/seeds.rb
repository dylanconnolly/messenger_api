# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

Message.delete_all
UserConversation.delete_all
Conversation.delete_all
User.delete_all

dylan = User.create(name: "Dylan")
bob = User.create(name: "Bob")
lauren = User.create(name: "Lauren")
chris = User.create(name: "Chris")

convo1 = Conversation.create
convo2 = Conversation.create
convo3 = Conversation.create
convo4 = Conversation.create

convo1.users.push(dylan, bob)
convo2.users.push(dylan, lauren)
convo3.users.push(bob, lauren)
convo4.users.push(bob, chris)


4.times do
    Message.create(user: dylan, conversation: convo1, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 45.day))
end

2.times do
    Message.create(user: dylan, conversation: convo1, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 15.day))
end

2.times do
    Message.create(user: dylan, conversation: convo1, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 2.day))
end

3.times do
    Message.create(user: bob, conversation: convo1, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 30.day))
end

6.times do
    Message.create(user: bob, conversation: convo1, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 14.day))
end

2.times do
    Message.create(user: bob, conversation: convo1, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 6.day))
end

2.times do
    Message.create(user: bob, conversation: convo1, content: Faker::Lorem.sentence)
end

23.times do
    Message.create(user: dylan, conversation: convo1, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 28.day))
end

10.times do
    Message.create(user: lauren, conversation: convo2, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 14.day))
end

16.times do
    Message.create(user: dylan, conversation: convo2, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 16.day))
end

18.times do
    Message.create(user: lauren, conversation: convo3, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 22.day))
end

15.times do
    Message.create(user: bob, conversation: convo3, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 1.day))
end

25.times do
    Message.create(user: chris, conversation: convo4, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 7.day))
end

7.times do
    Message.create(user: bob, conversation: convo4, content: Faker::Lorem.sentence, created_at: (Time.zone.now - 19.day))
end