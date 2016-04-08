class User < Sequel::Model
  plugin :timestamps, :update_on_create => true
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