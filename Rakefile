Dir.glob('./{controllers,lib,services,config,models}/init.rb').each do |file|
  require file
end

require 'rake/testtask'
task :default => [:spec]

namespace :db do
  require 'sequel'
  Sequel.extension :migration

  desc 'Run migrations'
  task :migrate do
    puts "Environment: #{ENV['RACK_ENV'] || 'development'}"
    puts 'Migrating to latest'
    Sequel::Migrator.run(DB, 'db/migrations')
  end

  desc 'Perform migration reset (full rollback and migration)'
  task :reset do
    Sequel::Migrator.run(DB, 'db/migrations', target: 0)
    Sequel::Migrator.run(DB, 'db/migrations')
  end

  desc 'Populate the database with test values'
  task :seed do
    load './db/seeds/accounts_messages.rb'
  end

  desc 'Reset and repopulate database'
  task :reseed => [:reset, :seed]
end

desc 'Run all the tests'
Rake::TestTask.new(name=:spec) do |t|
  t.pattern = 'specs/*_spec.rb'
end

namespace :key do
  require 'rbnacl/libsodium'
  require 'base64'

  namespace :symmetric do
    desc 'Create rbnacl key'
    task :generate do
      key = RbNaCl::Random.random_bytes(RbNaCl::SecretBox.key_bytes)
      puts "KEY: #{Base64.strict_encode64 key}"
    end
  end
end
