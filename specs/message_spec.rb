
require_relative './spec_helper'

describe 'Testing Message resource routes' do
  before do
    Account.dataset.delete
    Channel.dataset.delete
    Message.dataset.delete
  end

  describe 'Creating new Messages' do
    it 'HAPPY: should create a new Message' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { sender: 'Demo Sender', receiver: 'Demo Receiver',message: 'hello'}.to_json
      post '/api/v1/message/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create Messages with null sender and receiver' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { message: 'hello'}.to_json
      post '/api/v1/message/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing messages' do
    it 'HAPPY: should find an existing message' do
      new_message = Message.create(sender: 'Kuan' ,receiver: 'pengyuchen')
      new_message.message = 'hello~~~~~'
      new_message.save
      get "/api/v1/message/#{new_message.sender}"
      _(last_response.status).must_equal 200
      results = JSON.parse(last_response.body)
      _(results[0]['id']).must_equal new_message.id
    end

    it 'SAD: should not find non-existent messages' do
      get "/api/v1/messages/#{invalid_id(Message)}"
      _(last_response.status).must_equal 404
    end
  end
=begin
  describe 'Getting an index of existing messages' do
    it 'HAPPY: should find list of existing messages' do
      (1..5).each { |i| Message.create(sender: 'Kuan', receiver: 'pengyuchen',message:"hello there #{i}") }
      result = get '/api/v1/message'
      msgs = JSON.parse(result.body)
      msgs.count.must_equal 5
    end
  end
=end
end
