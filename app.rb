require 'sinatra'
require 'yaml'
require 'json'

require_relative 'models/messages'

class MessengerAPI < Sinatra::Base

  get '/' do
    'Messenger service is up and running at /api/v1'
  end

  get '/api/v1/messages/?' do
  	Message.new.to_json
  end

  get '/api/v1/messages/:id.json' do
    Message.new(params[:id]).to_json
  end
end
