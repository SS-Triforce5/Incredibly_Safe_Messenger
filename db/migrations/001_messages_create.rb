require 'sequel'

Sequel.migration do
  change do
    create_table(:messages) do
      primary_key :id
      String :sender, null: false
      String :receiver, null: false
      String :message_encrypted, text: true
      timestamp :created_at
    end
  end
end
