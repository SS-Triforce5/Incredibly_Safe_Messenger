require 'sinatra'
require 'yaml'
require 'json'

require_relative 'config/environments'
require_relative 'models/init'

class MessengerAPI < Sinatra::Base

  app_get_root = lambda do
    'Messenger service is up and running at /api/v1'
  end

  app_get_all_users = lambda do
    content_type 'application/json'

    User.all.to_json
  end
  app_get_user = lambda do
    content_type 'application/json'

    User.where(name: params[:id]).all.to_json
  end
  app_post_user = lambda do  
    User.create(JSON.parse(request.body.read))
  end

  app_get_all_messages = lambda do
    Message.all.to_json
  end
  app_get_message = lambda do
    Message.where(sender: params[:id]).or(receiver: params[:id]).all.to_json
  end
  app_post_message = lambda do  
    Message.create(JSON.parse(request.body.read))
  end

  app_get_all_channels = lambda do
    Channel.all.to_json
  end
  app_get_channel = lambda do
    Channel.where(channel: params[:id]).all.to_json
  end
  app_post_channel = lambda do  
    Channel.create(JSON.parse(request.body.read))
  end
  
  # Web App Views Routes
  get '/', &app_get_root

  get '/api/v1/user/?', &app_get_all_users
  get '/api/v1/user/:id.json', &app_get_user
  post '/api/v1/user/?', &app_post_user

  get '/api/v1/message/?', &app_get_all_messages
  get '/api/v1/message/:id.json', &app_get_message
  post '/api/v1/message/?', &app_post_message

  get '/api/v1/channel/?', &app_get_all_channels
  get '/api/v1/channel/:id.json', &app_get_channel
  post '/api/v1/channel/?', &app_post_channel  
  
end
