require_relative './spec_helper'

describe 'Testing Account resource routes' do
  before do
    Account.dataset.delete
    #Channel.dataset.delete
    Message.dataset.delete
  end

  describe 'Creating new account' do
    it 'HAPPY: should create a new unique account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: 'Demo_Account', email:'Demo@nthu.edu.tw', password: 'Demo Password' }.to_json
      post '/api/v1/account/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create duplicate accounts with same names' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: 'Demo_Account', email:'Demo@nthu.edu.tw', password: 'Demo Password' }.to_json
      post '/api/v1/account/', req_body, req_header
      post '/api/v1/account/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing Accounts' do
    it 'HAPPY: should find an existing account' do
      new_account = CreateNewAccount.call(username: 'Demo_Account',  email:'Demo@nthu.edu.tw',password: 'Demo Password')
      get "/api/v1/account/#{new_account.id}"
      _(last_response.status).must_equal 200
      results = JSON.parse(last_response.body)
      _(results[0]['username']).must_equal new_account.username
    end

    it 'SAD: should not find non-existent accounts' do
      get "/api/v1/account/#{invalid_id(Account)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Getting an index of existing Accounts' do
    it 'HAPPY: should find list of existing Accounts' do
      (1..5).each { |i|  CreateNewAccount.call(username: "Account_#{i}", email:"Demo_#{i}@nthu.edu.tw",password: "demo_#{i}") }
      result = get '/api/v1/account'
      msgs = JSON.parse(result.body)
      msgs.count.must_equal 5
    end
  end


  describe 'Authenticating an account' do
    before do
      @account = CreateNewAccount.call(
        username: 'soumya.ray',
        email: 'sray@nthu.edu.tw',
        password: 'soumya.password')
    end

    it 'HAPPY: should be able to authenticate a real account' do
      get '/api/v1/account/soumya.ray/authenticate?password=soumya.password'
      _(last_response.status).must_equal 200
    end

    it 'SAD: should not authenticate an account with a bad password' do
      get '/api/v1/account/soumya.ray/authenticate?password=guess.password'
      _(last_response.status).must_equal 401
    end

    it 'SAD: should not authenticate an account with an invalid username' do
      get '/api/v1/account/randomuser/authenticate?password=soumya.password'
      _(last_response.status).must_equal 401
    end

    it 'BAD: should not authenticate an account with password' do
      get '/api/v1/account/soumya.ray/authenticate'
      _(last_response.status).must_equal 401
    end
  end
end
