
class MessengerAPI < Sinatra::Base

  app_get_all_accounts = lambda do
    Account.all.to_json
  end

  app_get_account = lambda do
    content_type 'application/json'
    data = Account.where(id: :$find_id)
    call_data = data.call(:select, :find_id => params[:id])
    if !call_data.empty?
      JSON.pretty_generate(call_data)
    else
      halt 404, "Account #{params[:id]} not found"
    end
  end

  app_post_account = lambda do
    begin
      saved_account = Account.create(JSON.parse(request.body.read))
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400
    end
    new_location = URI.join(@request_url.to_s + '/', saved_account.id.to_s).to_s
    status 201
    headers('Location' => new_location)
  end

  get '/api/v1/account/?', &app_get_all_accounts
  get '/api/v1/account/:id', &app_get_account
  post '/api/v1/account/?', &app_post_account

end