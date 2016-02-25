require 'active_record'
require 'logger'

namespace :db do
  MIGRATIONS_DIR = 'db/migrate'
  ActiveRecord::Base.establish_connection(
    adapter:   'sqlite3',
    database:  'db/sqlite.db'
  )
  ActiveRecord::Base.logger = Logger.new('db/database.log')

  desc "Migrate the database"
  task :migrate do
    ActiveRecord::Migrator.migrate(MIGRATIONS_DIR, ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end
  desc 'Roll back the database schema to the previous version'
  task :rollback do
    ActiveRecord::Migrator.rollback(MIGRATIONS_DIR, ENV['STEP'] ? ENV['STEP'].to_i : 1)
  end
end
