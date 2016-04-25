Dir.glob('./{controllers,services,config,models}/init.rb').each do |file|
  require file
end

run MessengerAPI
