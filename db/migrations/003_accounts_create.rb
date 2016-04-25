require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      String :name, null: false, unique: true
      String :email
      String :password, null: false
      timestamp :created_at

      unique [:name, :email]
    end
  end
end
