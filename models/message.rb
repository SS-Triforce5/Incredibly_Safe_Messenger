require 'json'
require 'sequel'
require 'base64'
require_relative'lib/secure_model'

class Message < Sequel::Model
  include SecureModel
  plugin :timestamps, :update_on_create => true
  set_allowed_columns :sender, :receiver 

  def message=(message_plaintext)
    self.message_encrypted = encrypt(message_plaintext)
  end

  def message
    decrypt(message_encrypted)
  end

  def to_json(options = {})
    msg = message ? Base64.strict_encode64(message) : nil
    JSON.pretty_generate(
      {
        type: 'message',
        id: id,
        data: {
          sender: sender,
          receiver: receiver,
          message: msg,
          time: created_at
        }
      },
      options
    )
  end
end
