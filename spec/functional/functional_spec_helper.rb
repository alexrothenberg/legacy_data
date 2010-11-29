require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

ADAPTER = ENV['ADAPTER']

require 'generators/models_from_tables/models_from_tables_generator'

def initialize_connection connection_info
  ActiveRecord::Base.establish_connection(connection_info)

  # tell foreigner to reload the adapter
  Foreigner.load_adapter!
end
  

def connection_info_for example, adapter
  config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
  config["#{adapter}_#{example}"]
end

def execute_sql_script script_filename
  sql_script = File.read script_filename
  sql_script.split(';').each do |sql_statement|
    ActiveRecord::Base.connection.execute(sql_statement) unless sql_statement.blank?
  end
end
