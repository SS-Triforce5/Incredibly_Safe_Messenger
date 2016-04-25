# Service object to create new accounts using all columns
class CreateNewMessage
  def self.call(sender:, receiver:, message:)
    new_message = Message.new(sender: sender, receiver: receiver)
    new_message.message = message
    new_message.save
  end
end