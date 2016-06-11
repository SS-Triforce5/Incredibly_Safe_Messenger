
require_relative './spec_helper'

describe 'Testing Message resource routes' do
  before do
    Account.dataset.delete
    #Channel.dataset.delete
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

  describe 'Finding all messages of one user' do
    it 'HAPPY: should find all existing message of one user' do
      act1 = CreateNewAccount.call(username: 'Kuan', email:'abc@gmail.com',password:'123')
      act2 = CreateNewAccount.call(username: 'Edward', email:'def@gmail.com',password:'123')
      msg = CreateNewMessageFromSender.call(sender: 'Kuan' , receiver: 'Edward',message: 'Hi')
      msg2 = CreateNewMessageFromSender.call(sender: 'Edward' , receiver: 'Kuan',message: 'Hello!')
      get "/api/v1/message/Kuan"
      _(last_response.status).must_equal 200
      results = JSON.parse(last_response.body)
      _(results['data'].count).must_equal 2
    end

    it 'SAD: should not find non-exis user' do
      get "/api/v1/messages/junbo"
      _(last_response.status).must_equal 404
    end
  end



end
