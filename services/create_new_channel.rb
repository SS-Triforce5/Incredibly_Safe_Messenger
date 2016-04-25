# Service object to create new accounts using all columns
class CreateNewChannel
  def self.call(channel:, sender:, message:)
    channel = Channel.new(channel: channel)
    channel.sender = sender
    channel.message = message
    channel.save
  end
end