
require 'sinatra'
require 'yaml'
require 'json'

require_relative 'config/environments'
require_relative 'models/init'

class MessengerAPI < Sinatra::Base

  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  app_get_root = lambda do
    'Messenger service is up and running at /api/v1'
  end

  app_get_all_users = lambda do
    User.all.to_json
  end

  app_get_user = lambda do
    data = User.where(name: params[:id]).all
    if data
      JSON.pretty_generate(data)
    else
      halt 404, "User #{params[:id]} not found"
    end
  end

  app_post_user = lambda do
    User.create(JSON.parse(request.body.read))
  end

  app_get_all_messages = lambda do
    Message.all.to_json
  end

  app_get_message_json = lambda do
    data = Message.where(sender: params[:id]).or(receiver: params[:id]).all.to_json
    if data
       JSON.pretty_generate(data)
    else
      halt 404, "Messages of id #{params[:id]} not found"
    end
  end

  app_get_message = lambda do
  content_type 'application/json'
  message = Message.where(id: params[:id]).all
  if message
    JSON.pretty_generate(message)
  else
    halt 404, "MESSAGE NOT FOUND: #{id}"
  end
end


  app_post_message = lambda do
    begin
  saved_message= Message.create(JSON.parse(request.body.read))
   rescue => e
     logger.info "FAILED to create new message: #{e.inspect}"
     halt 400
   end
   new_location = URI.join(@request_url.to_s + '/', saved_message.id.to_s).to_s
   status 201
   headers('Location' => new_location)
  end

  app_get_all_channels = lambda do
    Channel.all.to_json
  end

  app_get_channel = lambda do
    data = Channel.where(channel: params[:id]).all.to_json
    if data
       JSON.pretty_generate(data)

    else
      halt 404, "Channel #{params[:id]} not found"
    end
  end




  app_post_channel = lambda do
   begin
    saved_channel= Channel.create(JSON.parse(request.body.read))
   rescue => e
    logger.info "FAILED to create new Channel: #{e.inspect}"
    halt 400
  end
  new_location = URI.join(@request_url.to_s + '/', saved_channel.id.to_s).to_s
  status 201
  headers('Location' => new_location)
  end

  # Web App Views Routes
  get '/', &app_get_root

  get '/api/v1/user/?', &app_get_all_users
  get '/api/v1/user/:id.json', &app_get_user
  post '/api/v1/user/?', &app_post_user

  get '/api/v1/message/?', &app_get_all_messages
  get '/api/v1/message/:id.json', &app_get_message_json
  get '/api/v1/message/:id', &app_get_message

  post '/api/v1/message/?', &app_post_message

  get '/api/v1/channel/?', &app_get_all_channels
  get '/api/v1/channel/:id.json', &app_get_channel
  post '/api/v1/channel/?', &app_post_channel

end
