class MessengerAPI < Sinatra::Base

  app_get_all_message = lambda do
    content_type 'application/json'
    begin
      account = Account.where(username: params[:username]).first
      all_messages = Message.where(sender: account.id).or(receiver: account.id).all
      JSON.pretty_generate(all_messages)
    rescue => e
      logger.info "FAILED to find messages for user #{params[:username]}: #{e}"
      halt 404
    end
  end

  app_get_message = lambda do
    begin
      content_type 'application/json'
      master = Account.where(username: params[:username]).first
      slave = Account.where(username: params[:with]).first
      range = (params[:after] ? Time.parse(params[:after]) : Time.at(0))..Time.now
      messages = Message.where(sender: master.id, receiver: slave.id, created_at: range)\
                 .or(sender: slave.id, receiver: master.id, created_at: range).all
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

  get '/api/v1/message/:username/?', &app_get_all_message
  get '/api/v1/message/:username/:with/?', &app_get_message
  post '/api/v1/message/?', &app_post_message

end
