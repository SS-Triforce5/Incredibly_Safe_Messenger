require 'json'
require 'sequel'



class User < Sequel::Model
  plugin :timestamps, :update_on_create => true
  #set_allowed_columns :name, :email
  def to_json(options = {})
    JSON.pretty_generate(
      {
        type: 'userinfo',
        id: id,
        data: {
          name: name,
          email: email,
          password: password,
          time: created_at
        }
      },
      options
    )
  end
end
