require 'json'
require 'sequel'
class Channel < Sequel::Model
  plugin :timestamps, :update_on_create => true
  def to_json(options = {})
    JSON.pretty_generate(
      {
        type: 'channel',
        id: id,
        data: {
          channel: channel,
          sender: sender,
          time: created_at
        }
      },
      options
    )
  end
end
