Messenger API
======
Welcome to Messenger API, a simple messenger backend API built using Ruby on Rails and PostgreSQL. This backend API exposes endpoints which allow for users to send messages to one another and track conversations. Available endpoints users are able to interact are outlined below and will provide examples of successful requests and responses for each endpoint.

Schema
-------

The database is currently designed leveraging four tables: **Users**, **Conversations**, **Messages**, and a **UserConversations** joins table. The decision to use a **Conversations** table with relationships to messages and users was made with the idea of further expansion of functionality in mind. Right now the Conversations are limited to only ever having **two users**. If a messenger app were to allow messenging between groups of people rather than strictly between two users, the **Conversations** table and its relationships would allow for this.

![Screen Shot 2021-02-23 at 1 36 15 PM](https://user-images.githubusercontent.com/54859243/108917719-69f07f80-75ed-11eb-893b-c77093c27017.png)

Getting Started
------

Assuming you have [Rails](https://rubyonrails.org/):

1. `git clone git@github.com:dylanconnolly/messenger_api.git`
2. `cd messenger_api`
3. `bundle install`
4. `rails db:{create,migrate,seed}`
5. `rails s`

The server should now be running and you can access its endpoints through your browser or a tool such as [Postman](https://www.postman.com/).

The database is seeded with messages, conversations, and users. The four users you can use when making calls are:
| User ID | Name |
| --- | --- |
1 | Dylan
2 | Bob
3 | Lauren
4 | Chris

Testing
---
This project uses RSpec as its testing suite. To run the spec while in the root directory run:


`
bundle exec rspec
`

Testing covers basic validation tests of the models, unit testing of model methods, and integration testing for requests. Test cases cover happy paths for each piece of funcionality as well as several sad paths. With more time, sad path testing and validation for requests would be built out further.

Endpoints
------
### Creating a message

A POST request to the messages endpoint will allow a new message to be created through two users. The request body has three required parameters: **sender_id** (integer), **recipient_id** (integer), **content** (string). A succesful response will return a `201` status code and the body of the response will contain the newly created message's data.

Example Request:
```
POST http://localhost:3000/api/v1/messages

{
    "sender_id": 1,
    "recipient_id": 2,
    "content": "This is a message sent from User 1 to User 2"
}
```
Example Response:
```
STATUS: 201

{
    "data": {
        "id": "4",
        "type": "message",
        "attributes": {
            "user_id": 1,
            "conversation_id": 13,
            "content": "This is a message sent from User 1 to User 2",
            "created_at": "2021-02-23T20:53:57.458Z"
        }
    }
}
```

### Requesting Messages Received by User from a Specific Sender

A GET request to `/api/v1/messages/{recipient_id}/{sender_id}` will retrieve only messages sent from the sender to the recipient. The response by default returns the 100 most recent messages. The endpoint also accepts an optional query parameter of `days_ago` (integer) to limit the response to only return messages from a certain number of days ago. The `days_ago` parameter has an upper limit of **30 days**. When a `days_ago` parameter is provided, the limit of 100 total messages is removed and all messages from the timeframe provided will be returned. Results are ordered with the most recent result appearing first.

Example Requests:
```
# will return 100 most recent messages that user 1 has received from user 2

GET http://localhost:3000/api/v1/messages/1/2

```

```
# will return ALL messages that user 1 has received from user 2 in the past 14 days

GET http://localhost:3000/api/v1/messages/1/2?days_ago=14
```

Example Response:
```
{
    "data": [
        {
            "id": "21",
            "type": "message",
            "attributes": {
                "user_id": 2,
                "conversation_id": 1,
                "content": "Odit deserunt dolores quos.",
                "created_at": "2021-02-23T21:19:25.193Z"
            }
        },
        {
            "id": "20",
            "type": "message",
            "attributes": {
                "user_id": 2,
                "conversation_id": 1,
                "content": "Nemo voluptates exercitationem cupiditate.",
                "created_at": "2021-02-23T21:19:25.192Z"
            }
        },
        {
            "id": "19",
            "type": "message",
            "attributes": {
                "user_id": 2,
                "conversation_id": 1,
                "content": "Ipsam deserunt laudantium odit.",
                "created_at": "2021-02-17T21:19:25.190Z"
            }
        },
    ...
    ]
}
```

### Requesting All Recent Messages

A GET request to `/api/v1/messages` will return all messages regardless of sender/receiver. The response by default returns the 100 most recent messages. The endpoint also accepts an optional query parameter of `days_ago` (integer) to limit the response to only return messages from a certain number of days ago. The `days_ago` parameter has an upper limit of **30 days**. When a `days_ago` parameter is provided, the limit of 100 total messages is removed and all messages from the timeframe provided will be returned. Results are ordered with the most recent result appearing first.

Example Requests:
```
# will return 100 most recent messages

GET http://localhost:3000/api/v1/messages

```
```
# will return ALL messages that were sent in the past 2 days

GET http://localhost:3000/api/v1/messages?days_ago=2
```

Example Response:
```
{
    "data": [
        {
            "id": "21",
            "type": "message",
            "attributes": {
                "user_id": 2,
                "conversation_id": 1,
                "content": "Odit deserunt dolores quos.",
                "created_at": "2021-02-23T21:19:25.193Z"
            }
        },
        {
            "id": "20",
            "type": "message",
            "attributes": {
                "user_id": 2,
                "conversation_id": 1,
                "content": "Nemo voluptates exercitationem cupiditate.",
                "created_at": "2021-02-23T21:19:25.192Z"
            }
        },
        {
            "id": "103",
            "type": "message",
            "attributes": {
                "user_id": 2,
                "conversation_id": 3,
                "content": "Ab debitis natus facere.",
                "created_at": "2021-02-22T21:19:25.326Z"
            }
        },
    ...
    ]
}
```

Considerations, Design Decisions, Improvements
---

My main consideration for design of this API was taking into consideration future iterations of this API and making design decisions based off that. I toiled with the idea of simplifying the database structure to only having a **users** and a **messages** table and tracking the sender and recipient directly on the messages table. This, however, I felt was too limiting and would make expanding functionality in the future a more difficult proccess. By using a **conversations** table, I feel this application can be expanding more easily to allow group conversations similar to text messages or other chat applications. Additionally, when considering practical use for a messenging application, a user would expect to see their conversation history with a particular user. Having conversations house the messages between two users allows for an easy and efficient way to deliver this data to a potential front end application.

A drawback of this design decision is it more complex to surface the data surrounding who the recipient of a message is without going through the conversation that a message belongs to. This is apparent when being asked to provide ALL recent messages (not recent messages between two users). The message data that is immediately surfaced could be considered less than ideal for a UI/UX designer that is hoping to use this information to display the sender and recipient of said messages.

As far as improvements/next steps go, I would likely focus on building out another data level (such as a facade) to aggregate message information and be able to display more useful information (such as message's recipient) when a request is made for ALL recent messages. Building out more robust testing and ensuring the application gracefully handles errors or exceptions would be another main focus point moving forward. Given the time constraint for this project, I relied on first building happy path tests which were used to drive the development of features and returning later to consider sad paths and edge cases. I would also look to build out the conversations functionality a bit more. Although not a specified requirement, exposing an endpoint to get the conversation history between two users (rather than just one user's messages sent to a specific recipient) would provide a better user experience when viewing messages.
