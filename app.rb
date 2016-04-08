require 'sinatra'
require 'yaml'
require 'json'

require_relative 'config/environments'
require_relative 'models/init'

class MessengerAPI < Sinatra::Base

  app_get_root = lambda do
    'Messenger service is up and running at /api/v1'
  end

  app_get_all_messages = lambda do
    Message.all.to_json
  end

  app_get_someone_messages = lambda do
    Message.where(sender: params[:id]).or(receiver: params[:id]).all.to_json
  end

  app_post_messages = lambda do  
    Message.create(JSON.parse(request.body.read))
  end




  # Web App Views Routes
  get '/', &app_get_root
  get '/api/v1/messages/?', &app_get_all_messages
  post '/api/v1/messages/?', &app_post_messages
  get '/api/v1/messages/:id.json', &app_get_someone_messages
end
