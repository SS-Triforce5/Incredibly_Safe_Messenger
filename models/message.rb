require 'json'
require 'sequel'
require 'base64'

class Message < Sequel::Model
  plugin :timestamps, :update_on_create => true
  set_allowed_columns :sender, :receiver
  many_to_one :who_send, class: :Account


  def message=(message_plaintext)
    self.message_encrypted = SecureDB.encrypt(message_plaintext) if message_plaintext
  end

  def message
    SecureDB.decrypt(message_encrypted)
  end

  def to_json(options = {})
    JSON.pretty_generate(
      {
        type: 'message',
        id: id,
        data: {
          sender: sender,
          receiver: receiver,
          message: message,
          time: created_at
        }
      },
      options
    )
  end
end
