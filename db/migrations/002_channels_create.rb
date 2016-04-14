require 'sequel'


Sequel.migration do
  change do
    create_table(:channels) do
      primary_key :id
      integer :channel
      String :sender, null: false
      String :message
      timestamp :created_at
    end
  end
end