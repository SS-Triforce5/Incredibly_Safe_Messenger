# Sinatra Application Controllers
class ShareConfigurationsAPI < Sinatra::Base
  find_all_message = lambda do
    content_type 'application/json'

    begin
      account = Account.where(username: params[:username]).first
      all_messages = FindAllAccountMessages.call(account)
      JSON.pretty_generate(data: all_messages)
    rescue => e
      logger.info "FAILED to find messages for user #{params[:username]}: #{e}"
      halt 404
    end
  end
    get '/api/v1/account/:username/messages/?', &find_all_message
end
