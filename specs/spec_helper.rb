ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
Dir.glob('./{controllers,lib,services,config,models}/init.rb').each do |file|
  require file
end


include Rack::Test::Methods

def app
  MessengerAPI
end

def invalid_id(resource)
  (resource.max(:id) || 0) + 1
end

def random_str(size)
  chars = [('a'..'z'),('A'..'Z'),('0'..'9')].map(&:to_a).flatten
  chars.sample(size).join
end

def client_signed(data_hash)
  app_secret_key = JOSE::JWK.from_okp(
    [:Ed25519, Base64.decode64(ENV['APP_SECRET_KEY'])])
  app_secret_key.sign(data_hash.to_json).compact
end

def authorized_account_token(credentials)
  signed_credentials = client_signed(credentials)
  _,auth_token = AuthenticateAccount.call(signed_credentials)
  auth_token
end

def create_client_account(registration_hash)
  signed_registration=client_signed(registration_hash)
  CreateNewAccount.call(signed_registration)
end
