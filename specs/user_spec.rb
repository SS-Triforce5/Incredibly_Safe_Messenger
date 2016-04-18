require_relative './spec_helper'

describe 'Testing User resource routes' do
  before do
    User.dataset.delete
    Channel.dataset.delete
    Message.dataset.delete
  end

  describe 'Creating new user' do
    it 'HAPPY: should create a new unique user' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { name: 'Demo User',  password: 'Demo Password' }.to_json
      post '/api/v1/user/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create duplicate accounts with same names' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { name: 'Demo User', password: 'Demo Password' }.to_json
      post '/api/v1/user/', req_body, req_header
      post '/api/v1/user/', req_body, req_header

      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing Users' do
    it 'HAPPY: should find an existing user' do
      new_user = User.create(name: 'Demo User1', password: 'Demo Password')
      get "/api/v1/user/#{new_user.id}"
      _(last_response.status).must_equal 200
      results = JSON.parse(last_response.body)
      _(results[0]['id']).must_equal new_user.id
    end

    it 'SAD: should not find non-existent users' do
      get "/api/v1/user/#{invalid_id(User)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Getting an index of existing Users' do
    it 'HAPPY: should find list of existing Users' do
      (1..5).each { |i| User.create(name: "User #{i}", password: "demo #{i}") }
      result = get '/api/v1/user'
      msgs = JSON.parse(result.body)
      msgs.count.must_equal 5
    end
  end
end
