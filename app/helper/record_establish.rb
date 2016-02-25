require 'yaml'
require "active_record"

config = YAML.load_file(File.join(File.dirname(__FILE__), "../../config/database.yml"))

ActiveRecord::Base.establish_connection(config)
