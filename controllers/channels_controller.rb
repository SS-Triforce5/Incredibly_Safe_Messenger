class MessengerAPI < Sinatra::Base

  app_get_all_channels = lambda do
    Channel.all.to_json
  end

  app_get_channel = lambda do
    data = Channel.where(channel: :$find_id)
    call_data = data.call(:select, :find_id => params[:id].to_i )
    if !call_data.empty?
      JSON.pretty_generate(call_data)
    else
      logger.info call_data
      halt 404, "Channel #{params[:id]} not found"
    end
  end

  app_post_channel = lambda do
    begin
      data = JSON.parse(request.body.read)
      saved_channel = CreateNewChannel.call(
        channel: data['channel'].to_i, 
        sender: data['sender'],
        message: data['message'])
    rescue => e
      logger.info "FAILED to create new Channel: #{e.inspect}"
      halt 400
    end
    new_location = URI.join(@request_url.to_s + '/', saved_channel.id.to_s).to_s
    status 201
    headers('Location' => new_location)
  end

  get '/api/v1/channel/?', &app_get_all_channels
  get '/api/v1/channel/:id.json', &app_get_channel
  post '/api/v1/channel/?', &app_post_channel

end