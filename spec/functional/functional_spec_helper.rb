require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

ADAPTER = ENV['ADAPTER']


def initialize_connection connection_info
  ActiveRecord::Base.establish_connection(connection_info)

  begin
    require "foreigner/connection_adapters/#{ActiveRecord::Base.connection.adapter_name.downcase}_adapter"
  rescue LoadError
    #foreigner does not support all adapters (i.e. sqlite3)
  end
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
