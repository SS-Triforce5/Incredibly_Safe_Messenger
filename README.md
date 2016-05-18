#  Incredibly_Safe_Messenger

We devote to provide our user the safest online chatting service so FBI cannot spy on them.

##Description
Our project is to create a real-time messenger for users who sign up to our service.
Message records will be finely secured so no one apart from the conversation could have access to those messages.
## heroku
###Client
`http://messenger-client.herokuapp.com`
###API
`http://incredibly-safe-messenger-api.herokuapp.com`
## Routes

### Application Routes
- GET `/`: root route

### User Routes
- GET `api/v1/user/`: returns a json list of all users
- GET `api/v1/user/:id.json`: returns a json of all information about a user
- POST `api/v1/projects/`: creates a new user

### Message Routes
- GET `api/v1/message/`: returns a json list of all messages
- GET `api/v1/message/:id.json`: returns a json of all information about a message
- POST `api/v1/message/`: creates a new message

### Channel Routes
- GET `api/v1/channel/`: returns a json list of all channel
- GET `api/v1/channel/:id.json`: returns a json of all information about a channel
- POST `api/v1/channel/`: creates a new channel

##Installation

### Install

Install this API by cloning the *relevant branch* and installing required gems:

    $ bundle install

### Testing

Test this API by running:

    $ bundle exec rake spec

### Execute

Run this API during deployment:

    $ bundle exec rackup

or use autoloading during development:

    $ bundle exec rerun rackup

## Contributors
    * Peng-Yu Chen
    * Kuan Yu Chen
    * Edward Song
