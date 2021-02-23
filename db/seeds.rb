# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Message.delete_all
UserConversation.delete_all
Conversation.delete_all
User.delete_all

dyl = User.create(name: "Dylan")
jess = User.create(name: "Jess")
steph = User.create(name: "Steph")

convo = Conversation.create
convo2 = Conversation.create
convo3 = Conversation.create

UserConversation.create(conversation: convo, user: dyl)
UserConversation.create(conversation: convo, user: jess)
UserConversation.create(conversation: convo2, user: dyl)
UserConversation.create(conversation: convo2, user: steph)
UserConversation.create(conversation: convo3, user: steph)
UserConversation.create(conversation: convo3, user: jess)


Message.create(user: dyl, conversation: convo, message: "First text")
Message.create(user: dyl, conversation: convo, message: "Can you hear me?")
Message.create(user: jess, conversation: convo, message: "Hi yea I can.")
Message.create(user: dyl, conversation: convo, message: "Cool cool")
Message.create(user: jess, conversation: convo, message: "this works")
Message.create(user: jess, conversation: convo, message: "Another message")
Message.create(user: dyl, conversation: convo, message: "bye bye")
Message.create(user: dyl, conversation: convo2, message: "Hi Steph")
Message.create(user: steph, conversation: convo2, message: "Hi dyl")
Message.create(user: steph, conversation: convo3, message: "Hi there")
Message.create(user: jess, conversation: convo3, message: "Hi hi")