
class Message
  STORE_FILE = 'db/messages.yaml'.freeze
  
  def initialize(id = '')
  	messages = YAML::load(File.read(STORE_FILE))
  	@messages = (id == '') ? messages : messages[id]
  end
  
  def to_yaml
    @messages.to_yaml
  end

  def to_json(options = {})
    @messages.to_json
  end
end