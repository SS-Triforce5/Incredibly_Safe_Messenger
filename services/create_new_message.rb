# Service object to create new accounts using all columns
class CreateNewMessage
  def self.call(sender:, receiver:,recived_channel: ,message:)
    new_message = Message.new(sender: sender, receiver: receiver, recived_channel: recived_channel)
    new_message.message = message
    new_message.save
  end
end
