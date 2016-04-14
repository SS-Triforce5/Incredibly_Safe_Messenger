require_relative './spec_helper'

describe 'Testing User resource routes' do
  before do
    User.dataset.delete
    Channel.dataset.delete
    Message.dataset.delete
  end

  describe 'Creating new user' do
    it 'HAPPY: should create a new user' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { name: 'Demo User' }.to_json
      post '/api/v1/user/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create Users with duplicate names' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { name: 'Demo User' }.to_json
      post '/api/v1/user/', req_body, req_header
      post '/api/v1/user/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing Users' do
    it 'HAPPY: should find an existing user' do
      new_user = User.create(name: 'demo user')
      new_configs = (1..3).map do |i|
        new_user.add_configuration(filename: "user_file#{i}.rb")
      end

      get "/api/v1/user/#{new_user.id}"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_user.id
      3.times do |i|
        _(results['relationships'][i]['id']).must_equal new_configs[i].id
      end
    end

    it 'SAD: should not find non-existent users' do
      get "/api/v1/user/#{invalid_id(User)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Getting an index of existing Users' do
    it 'HAPPY: should find list of existing Users' do
      (1..5).each { |i| User.create(name: "User #{i}") }
      result = get '/api/v1/user'
      projs = JSON.parse(result.body)
      _(projs['data'].count).must_equal 5
    end
  end

end