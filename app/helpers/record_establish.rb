require 'active_record'
require 'dotenv'

dev_config = {
  :adapter => 'sqlite3',
  :database => 'db/sqlite.db',
  :encoding => 'utf8',
}
Dotenv.load
ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || dev_config)
