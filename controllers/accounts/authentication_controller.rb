# Sinatra Application Controllers
class MessengerAPI < Sinatra::Base
  post_account_authenticate = lambda do
    content_type 'application/json'

    begin
        account, auth_token = AuthenticateAccount.call(request.body.read)
      rescue => e
        halt 401, e.to_s
    end

    { account: account, auth_token: auth_token }.to_json
  end

  get_github_sso_url = lambda do
     content_type 'application/json'
     gh_url = 'https://github.com/login/oauth/authorize'
     client_id = ENV['GH_CLIENT_ID']
     scope = 'user:email'
     { url: "#{gh_url}?client_id=#{client_id}&scope=#{scope}" }.to_json
   end



  get_github_account = lambda do
     content_type 'application/json'
     begin
       sso_account, auth_token = RetrieveSsoAccount.call(params['code'])
       { account: sso_account, auth_token: auth_token }.to_json
     rescue => e
       logger.info "FAILED to validate Github account: #{e.inspect}"
       halt 400
     end

   end

post '/api/v1/account/authenticate', &post_account_authenticate
get '/api/v1/github_sso_url', &get_github_sso_url
get '/api/v1/github_account', &get_github_account

end
