require 'json'
require 'sequel'
require 'base64'

class Message < Sequel::Model
  plugin :timestamps, :update_on_create => true
<<<<<<< HEAD
  set_allowed_columns :sender, :receiver 
=======
  set_allowed_columns :sender, :receiver
  many_to_one :who_send, class: :Account

>>>>>>> f5e70f2c3815b47c7a8bbef040eebf56f21d57ec

  def message=(message_plaintext)
    self.message_encrypted = SecureDB.encrypt(message_plaintext) if message_plaintext
  end

  def message
    SecureDB.decrypt(message_encrypted)
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
<<<<<<< HEAD
          message: msg,
=======
          recived_channel: recived_channel,
          message_base64: msg,
>>>>>>> f5e70f2c3815b47c7a8bbef040eebf56f21d57ec
          time: created_at
        }
      },
      options
    )
  end
end
