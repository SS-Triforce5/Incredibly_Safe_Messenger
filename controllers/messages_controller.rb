class MessengerAPI < Sinatra::Base
  app_get_all_messages = lambda do
    Message.all.to_json
  end

  app_get_message_json = lambda do
    data = Message.where(sender: params[:id]).or(receiver: params[:id]).all.to_json
    if !data.empty?
      JSON.pretty_generate(data)
    else
      halt 404, "Messages of id #{params[:id]} not found"
    end
  end

  app_get_message = lambda do
    content_type 'application/json'
    messages = Message.where(sender: :$find_id)
    call_message = messages.call(:select, :find_id => params[:id])
    if !call_message.empty?
      JSON.pretty_generate(call_message)
    else
      halt 404, "MESSAGE NOT FOUND: #{params[:id]}"
    end
  end

  app_post_message = lambda do
    begin
      data = JSON.parse(request.body.read)
      saved_message = CreateNewMessage.call(
        sender: data['sender'],
        receiver: data['receiver'],
        message: data['message'])
    rescue => e
      logger.info "FAILED to create new message: #{e.inspect}"
      halt 400
     end
     new_location = URI.join(@request_url.to_s + '/', saved_message.id.to_s).to_s
     status 201
     headers('Location' => new_location)
  end

  get '/api/v1/message/?', &app_get_all_messages
  get '/api/v1/message/:id.json', &app_get_message_json
  get '/api/v1/message/:id', &app_get_message
  post '/api/v1/message/?', &app_post_message

end
