require 'sinatra'
require 'yaml'
require 'json'
require 'rack/ssl-enforcer'

class MessengerAPI < Sinatra::Base
 enable :logging

 configure :production do
 use Rack::SslEnforcer
 end

  def authenticated_account(env)
    scheme, auth_token = env['HTTP_AUTHORIZATION'].split(' ')
    account_payload = JSON.load SecureClientMessage.decrypt(auth_token)
    (scheme =~ /^Bearer$/i) ? account_payload : nil
  end

  def authorized_account?(env, id)
    account = authenticated_account(env)
    account['id'] == id.to_i
  rescue
    false
  end

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
