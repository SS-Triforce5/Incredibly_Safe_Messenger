acc1 = CreateNewAccount.call(
  username: 'soumya.ray', email: 'sray@nthu.edu.tw', password: 'mypassword')

acc2 = CreateNewAccount.call(
  username: 'kuan', email: 'kuan@nthu.edu.tw', password: 'cool')

acc3 = CreateNewAccount.call(
    username: 'song', email: 'Song@nthu.edu.tw', password: 'test')

acc4 = CreateNewAccount.call(
        username: 'pengyu', email: 'pengyu@nthu.edu.tw', password: 'test')

msg11 = CreateNewMessageFromSender.call(sender:
  acc1, receiver: acc3,
        message: 'hi')

msg23 = CreateNewMessageFromSender.call(sender:
  acc2, receiver: acc4,
        message: 'cool')
msg14 = CreateNewMessageFromSender.call(sender:
  acc1, receiver: acc4,
                message: 'wow')

puts 'Database seeded!'
DB.tables.each { |table| puts "#{table} --> #{DB[table].count}" }
