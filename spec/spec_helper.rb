require 'rubygems'
require 'activerecord'
# require 'active_record/connection_adapters/oracle_enhanced_adapter'



## TODO parameterize this ....
ActiveRecord::Base.establish_connection({:adapter=>'sqlite3', :database=> ":memory:"})

ActiveRecord::Base.connection.create_table :posts do |t|
  t.string :title
  t.text   :body
end
ActiveRecord::Base.connection.create_table :comments do |t|
  t.integer :post_id
  t.text    :body
end


# $LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'legacy_data'

require 'spec'
require 'spec/autorun'

Spec::Runner.configure do |config|
  
end

### Load the rails generator code
require 'rails_generator'
require 'rails_generator/scripts'
require 'rails_generator/scripts/generate'

Rails::Generator::Base.reset_sources
def add_source(path)
  Rails::Generator::Base.append_sources(Rails::Generator::PathSource.new(:builtin, path))
end

add_source(File.dirname(__FILE__) + '/../generators')

def load_generator(generator_name="models_from_tables", args=[])
  Rails::Generator::Base.instance(generator_name,
                                  (args.dup << '--quiet'), 
                                  {:generator=>generator_name, :command=>:create, :destination=>RAILS_ROOT})    
end

def invoke_generator(generator_name, args, the_command= :create)
  generator = load_generator(generator_name, args)
  LegacyData::TableClassNameMapper.stub!(:log)    
  cmd = generator.command(the_command)
  cmd.stub!(:logger).and_return(stub('stub').as_null_object)
  cmd.invoke!
end
