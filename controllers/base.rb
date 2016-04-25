require 'sinatra'
require 'yaml'
require 'json'

class MessengerAPI < Sinatra::Base
  enable :logging

  before do
    host_url = "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  app_get_root = lambda do
    'Messenger service is up and running at /api/v1'
  end

  # Web App Views Routes
  get '/', &app_get_root

end
