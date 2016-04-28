require 'sequel'

Sequel.migration do
  change do
    create_join_table(account_id: :accounts, channel_id: :channels)
  end
end
