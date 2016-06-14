
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
    @my_account = create_client_account(username: 'Kuan', email:'abc@gmail.com',password:'123')
    @other_account = create_client_account(username: 'Edward', email:'def@gmail.com',password:'777')
    @other_account2 = create_client_account(username: 'Tim', email:'ya@gmail.com',password:'888')
    msg = CreateNewMessageFromSender.call(sender: 'Kuan' , receiver: 'Edward',message: 'Hi')
    msg2 = CreateNewMessageFromSender.call(sender: 'Kuan' , receiver: 'Tim',message: 'Hello!')
    it 'HAPPY: should find all existing message of one user' do
      auth_token = authorized_account_token(username: 'Kuan', password: '123')
      get "/api/v1/message/#{@my_account.username}" ,nil,
        'HTTP_AUTHORIZATION' => "Bearer #{auth_token}"
      _(last_response.status).must_equal 200
      results = JSON.parse(last_response.body)
      _(results['data'].count).must_equal 2
    end

    it 'SAD: should not find non-exis user' do
      get "/api/v1/messages/junbo"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Finding the message between two users' do
    @my_account = create_client_account(username: 'Kuan', email:'abc@gmail.com',password:'123')
    @other_account = create_client_account(username: 'Edward', email:'def@gmail.com',password:'777')
    msg = CreateNewMessageFromSender.call(sender: 'Kuan' , receiver: 'Edward',message: 'Hi')
    msg2 = CreateNewMessageFromSender.call(sender: 'Edward' , receiver: 'Kuan',message: 'Good morning!')
    msg3 = CreateNewMessageFromSender.call(sender: 'Kuan' , receiver: 'Edward',message: 'Its raining')

    it 'HAPPY: should find all messages between two users' do
      auth_token = authorized_account_token(username: 'Kuan', password: '123')
      get "/api/v1/message/#{@my_account.username}/#{@other_account.username}" ,nil,
        'HTTP_AUTHORIZATION' => "Bearer #{auth_token}"
      _(last_response.status).must_equal 200
      results = JSON.parse(last_response.body)
      _(results['data'].count).must_equal 3
    end
  end


end
