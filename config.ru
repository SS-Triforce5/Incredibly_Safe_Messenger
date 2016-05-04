Dir.glob('./{controllers,lib,services,config,models}/init.rb').each do |file|
  require file
end

run MessengerAPI
