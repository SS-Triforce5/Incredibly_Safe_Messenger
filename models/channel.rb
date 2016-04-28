require 'json'
require 'sequel'
require 'base64'
require_relative'lib/secure_model'

class Channel < Sequel::Model
  include SecureModel
  plugin :timestamps, :update_on_create => true
  set_allowed_columns :channel, :sender
  many_to_one :sender, class: :Account
  many_to_many :channel_member,
  class: :Account, join_table: :accounts_channels,
  left_key: :channel_id, right_key: :account_id

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
        type: 'channel',
        id: id,
        data: {
          channel: channel,
          sender: sender,
          message_base64: msg,
          time: created_at
        }
      },
      options
    )
  end
end
