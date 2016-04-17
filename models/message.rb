require 'json'
require 'sequel'
class Message < Sequel::Model
  plugin :timestamps, :update_on_create => true
  set_allowed_columns :sender, :receiver, :message
  def to_json(options = {})
    JSON.pretty_generate(
      {
        type: 'message',
        id: id,
        data: {
          sender: sender,
          receiver: receiver,
          time: created_at
        }
      },
      options
    )
  end
end
