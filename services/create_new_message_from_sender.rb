# Service object to create new accounts using all columns
class CreateNewMessageFromSender
  def self.call(sender:, receiver:,message:)
    new_message = sender.add_send_message(receiver: receiver.id)
    new_message.message = message if message
    new_message.save
  end
end
