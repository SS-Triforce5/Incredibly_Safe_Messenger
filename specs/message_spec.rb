require_relative './spec_helper'

describe 'Testing Message resource routes' do
  before do
    User.dataset.delete
    Channel.dataset.delete
    Message.dataset.delete
  end

  describe 'Creating new Messages' do
    it 'HAPPY: should create a new Message' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { sender: 'Demo Sender' , receiver: 'Demo Receiver' }.to_json
      post '/api/v1/message/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create Messages with null sender and receiver' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {sender:''}.to_json
      post '/api/v1/message/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing messages' do
    it 'HAPPY: should find an existing message' do
      new_message = Message.create(sender: 'Kuan' , receiver: 'pengyuchen',message: 'hello there')

=begin
    new_configs = (1..3).map do |i|
        new_message.add_configuration(filename: "Message_file#{i}.rb")
      end
=end
      get "/api/v1/message/#{new_message.id}"
      _(last_response.status).must_equal 200
      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_message.id

=begin
      3.times do |i|
        _(results['relationships'][i]['id']).must_equal new_configs[i].id
      end
=end
    end

    it 'SAD: should not find non-existent projects' do
      get "/api/v1/message/#{invalid_id(Message)}"
      _(last_response.status).must_equal 404
    end
  end

=begin
  describe 'Getting an index of existing Messages' do
    it 'HAPPY: should find list of existing Messages' do
      (1..5).each { |i| Message.create(sender: "Sender #{i}" , receiver: "Receiver #{i}") }
      result = get '/api/v1/message'
      mes = JSON.parse(result.body)
      _(mes['id'].first.count).must_equal 5
    end
  end
=end
end
