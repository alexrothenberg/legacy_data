require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

def initialize_connection connection_info
  ActiveRecord::Base.establish_connection(connection_info)

  begin
    require "foreigner/connection_adapters/#{ActiveRecord::Base.connection.adapter_name.downcase}_adapter"
  rescue LoadError
    #foreigner does not support all adapters (i.e. sqlite3)
  end
end
  

def connection_info_for example, adapter
  connections = {
    :blog   => {'mysql'   => {:adapter=>'mysql',           :database=> "legacy_data_blog", :username=>'root', :password=>''},
                'sqlite3' => {:adapter=>'sqlite3',         :database=> ":memory:"                                          },
                'oracle'  => {:adapter=>'oracle_enhanced', :database=> "",                 :username=>'root', :password=>''}
                },
    :drupal => {'mysql'   => {:adapter=>'mysql',           :database=> "drupal_6_14",      :username=>'root', :password=>''}
               }
    }

  connections[example][adapter]
end

