require_relative './spec_helper'

describe 'Testing Channel resource routes' do
  before do
    Account.dataset.delete
    Channel.dataset.delete
    Message.dataset.delete
  end

  describe 'Creating new Channel' do
    it 'HAPPY: should create a new Channel' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { sender: 'Demo Channel' }.to_json
      post '/api/v1/channel/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create channel with null sender' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { }.to_json
      post '/api/v1/channel/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end
end
