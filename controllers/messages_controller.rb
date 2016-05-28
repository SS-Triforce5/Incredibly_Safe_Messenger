class MessengerAPI < Sinatra::Base

  app_get_all_messages = lambda do
    Message.all.to_json
  end

  app_get_message = lambda do
    begin
      content_type 'application/json'
      user = Account.where(username: params[:username]).first
      range = (params[:after] ? Time.parse(params[:after]) : Time.at(0))..Time.now
      messages = Message.where(sender: user.id, created_at: range)\
                 .or(receiver: user.id, created_at: range).all
      JSON.pretty_generate(messages)
    rescue => e
      logger.info "FAILED to get message of #{params[:username]}: #{e.inspect}"
      halt 400
    end
  end

  app_post_message = lambda do
    begin
      data = JSON.parse(request.body.read)
      saved_message = CreateNewMessageFromSender.call(
        sender: data['sender'],
        receiver: data['receiver'],
        message: data['message'])
    rescue => e
      logger.info "FAILED to create new message: #{e.inspect}"
      halt 400
     end
     new_location = URI.join(@request_url.to_s + '/', data['sender'] ).to_s
     status 201
     headers('Location' => new_location)
  end

  get '/api/v1/message/?', &app_get_all_messages
  get '/api/v1/message/:username/?', &app_get_message
  post '/api/v1/message/?', &app_post_message

end
