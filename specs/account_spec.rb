require_relative './spec_helper'

describe 'Testing Account resource routes' do
  before do
    Account.dataset.delete
    #Channel.dataset.delete
    Message.dataset.delete
  end

  describe 'Creating new account' do
    before do
      @registration_data = {
        username: 'test.name',
        passowrd: 'mypass',
        email: 'test@email.com'}
      @req_body = client_signed(@registration_data)
    end
    it 'HAPPY: should create a new unique account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/account/', @req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create duplicate accounts with same names' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/account/', @req_body, req_header
      post '/api/v1/account/', @req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end

    it 'BAD: should not create account unless requested from authorized app' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = @registration.to_json
      post '/api/v1/account/', req_body, req_header
      post '/api/v1/account/', req_body, req_header
      _(last_response.status).must_equal 401
      _(last_response.location).must_be_nil
    end
  end

  describe 'Testing unit level properties of accounts' do
    before do
      @original_password = 'mypassword'
      @account = create_client_account(username: 'Demo_Account',  email:'Demo@email.com' , password:@original_password)
    end

    it 'Happy : should hash the password' do
      _(@account.password_hash).wont_equal @original_password
    end

    it 'Happy : should re-salt the password' do
      hashed = @account.password_hash
      @account.password = @original_password
      @account.save
      _(@account.password_hash).wont_equal hashed
    end
  end

  describe 'Finding existing Accounts' do
    before do
      @new_account = create_client_account(username: 'Demo_Account',  email:'Demo@email.com' , password: 'mypassword')
      @auth_token = authorized_account_token(usernae: 'Demo_Account' , password:'mypassword')
    end
    it 'HAPPY: should find an existing account' do
      get "/api/v1/account/#{@new_account.id}",nil,
        {"HTTP_AUTHORIZATION" => "Bearer #{@auth_token}" }
      _(last_response.status).must_equal 200
      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal @new_account.id
    end

    it 'SAD: should not return wrong account' do
      get "/api/v1/account/#{random_str(10)}",nil,
      {"HTTP_AUTHORIZATION" => "Bearer #{@auth_token}" }
      _(last_response.status).must_equal 401
    end

    it 'SAD: should not return account without authorization' do
      get "/api/v1/account/#{@new_account.id}"
      _(last_response.status).must_equal 401
    end
  end



  describe 'Authenticating an account' do
    def login_with(username:,password:,client_auth: true)
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      credentials = { username:username , passowrd:password }.to_json

      if client_auth
        app_secret_key = JOSE::JWK.from_okp([:Ed25519, Base64.decode64(ENV['APP_SECRET_KEY'])])
        req_body= app_secret_key.sign(credentials).compact
      else
        req_body = nil
      end

      post '/api/v1/account/authenticate',req_body,req_header
    end
    before do
      @account = create_client_account(
        username: 'soumya.ray',
        email: 'sray@nthu.edu.tw',
        password: 'soumya.password')
    end

    it 'HAPPY: should be able to authenticate a real account' do
      login_with(username: 'soumya.ray' , password:'soumya.password')
      _(last_response.status).must_equal 200
      response = JSON.parse(last_response.body)
      _(response['account']).wont_equal nil
      _(response['auth_token']).wont_equal nil
    end

    it 'SAD: should not authenticate an account with wrong password' do
      login_with(username: 'soumya.ray' , password:'kuan.password')
      _(last_response.status).must_equal 401
    end

    it 'SAD: should not authenticate an account with an invalid username' do
      login_with(username: 'KuanYu' , password:'soumya.password')
      _(last_response.status).must_equal 401
    end

    it 'BAD: should not authenticate an account without password' do
      login_with(username: 'soumya.ray' , password:'')
      _(last_response.status).must_equal 401
    end

    it 'BAD: should not authenticate valid credentials account without client-app authorization' do
      login_with(username: 'soumya.ray' , password:'soumya.password' , client_auth:false)
      _(last_response.status).must_equal 401
    end
  end
end
