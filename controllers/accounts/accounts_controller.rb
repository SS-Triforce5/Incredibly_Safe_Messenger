
class MessengerAPI < Sinatra::Base

  app_get_all_accounts = lambda do
    content_type 'application/json'
    data = BaseAccount.map{ |x| { username: x.username,
                                  type: x.type,
                                  updated_at: x.updated_at}}
    JSON.pretty_generate(data)
  end

  app_get_account_info = lambda do
    content_type 'application/json'

    id = params[:id]
    halt 401 unless authorized_account?(env, id)
    account = BaseAccount.where(id:  id).first

    if account
      JSON.pretty_generate(data: account)
    else
      halt 404, "Account #{params[:id]} not found"
    end
  end

  app_post_account = lambda do
    begin
      signed_full_registration = request.body.read
      new_account = CreateNewAccount.call(signed_full_registration)
    rescue ClientNotAuthorized => e
      halt 401, e.to_s
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400
    end
    new_location = URI.join(@request_url.to_s + '/', new_account.username.to_s).to_s
    status 201
    headers('Location' => new_location)
  end

  get '/api/v1/account/?', &app_get_all_accounts
  get '/api/v1/account/:id', &app_get_account_info
  post '/api/v1/account/?', &app_post_account

end
