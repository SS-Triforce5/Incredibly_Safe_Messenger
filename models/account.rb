require 'sequel'
require 'rbnacl/libsodium'
require 'base64'
require 'json'

# Holds and persists an account's information
class Account < Sequel::Model
  plugin :timestamps, update_on_create: true
<<<<<<< HEAD
  set_allowed_columns :username, :password ,:email
=======
  set_allowed_columns :username, :email
  one_to_many :send_message, class: :Message, key: :sender

<<<<<<< HEAD
>>>>>>> f5e70f2c3815b47c7a8bbef040eebf56f21d57ec
=======
>>>>>>> f5e70f2c3815b47c7a8bbef040eebf56f21d57ec

  def password=(new_password)
    new_salt = SecureDB.new_salt
    hashed = SecureDB.hash_password(new_salt, new_password)
    self.salt = new_salt
    self.password_hash = hashed
  end

  def password?(try_password)
    try_hashed = SecureDB.hash_password(salt, try_password)
    try_hashed == password_hash
  end

  def to_json(options = {})
    JSON({  type: 'account',
            username: username
          },
         options)
  end
end
