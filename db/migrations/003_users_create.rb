require 'sequel'


Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      string :name
      String :email
      String :password
      timestamp :created_at

      unique [:name, :email]
    end
  end
end