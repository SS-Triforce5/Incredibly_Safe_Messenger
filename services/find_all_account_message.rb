# Find all projects (owned and contributed to) by an account
class FindAllAccountMessages
  def self.call(account)
    my_messages = Message.where(sender: account.id).all
    received_message = Message.where(receiver: account.id).all
    my_messages + received_message
  end
end
