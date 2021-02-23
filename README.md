Messenger API
======
Welcome to Messenger API, a simple messenger backend API built using Ruby on Rails and PostgreSQL. This backend API exposes endpoints which allow for users to send messages to one another and track conversations. Available endpoints users are able to interact are outlined below and will provide examples of successful requests and responses for each endpoint.

Schema
-------

The database is currently designed leveraging four tables: **Users**, **Conversations**, **Messages**, and a **UserConversations** joins table. The decision to use a **Conversations** table with relationships to messages and users was made with the idea of further expansion of functionality in mind. Right now the Conversations are limited to only ever having **two users**. If a messenger app were to allow messenging between groups of people rather than strictly between two users, the **Conversations** table and its relationships would allow for this.

Getting Started
------

Assuming you have [Rails](https://rubyonrails.org/):

1. `git clone `
2. `cd messenger_api`
3. `bundle install`
4. `rails db:{create,migrate,seed}`
5. `rails s`

The server should now be running and you can access its endpoints through your browser or a tool such as [Postman](https://www.postman.com/).

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

Example Request:
```
GET http://localhost:3000/api/v1/messages/1/2

# this will return messages that user 1 has received from user 2
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

Example Request:
```
GET http://localhost:3000/api/v1/messages
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