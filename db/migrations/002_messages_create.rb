require 'sequel'

Sequel.migration do
  change do
    create_table(:messages) do
      primary_key :id
      foreign_key :sender, :base_accounts
      Integer :receiver, null: false
      String :message_encrypted, text: true
      timestamp :created_at
    end
  end
end
