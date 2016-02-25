require 'logger'
require_relative './app/helpers/record_establish'


MIGRATIONS_DIR = 'db/migrate'

namespace :db do
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
