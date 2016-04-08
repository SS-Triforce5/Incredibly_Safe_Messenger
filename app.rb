require 'sinatra'
require 'yaml'
require 'json'

require_relative 'config/environments'
require_relative 'models/init'

class MessengerAPI < Sinatra::Base

  get '/' do
    'Messenger service is up and running at /api/v1'
  end

  get '/api/v1/messages/?' do
    Message.all.to_json
  end

  get '/api/v1/messages/:id.json' do
    Message.where(sender: params[:id]).or(receiver: params[:id]).all.to_json
  end
end
