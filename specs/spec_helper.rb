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
