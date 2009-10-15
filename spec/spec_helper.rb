require 'rubygems'
require 'activerecord'
# require 'active_record/connection_adapters/oracle_enhanced_adapter'


# Since Legacy Data depends on Foreigner we need to have an ActiveRecord connection established
ActiveRecord::Base.establish_connection({:adapter=>'sqlite3', :database=> ":memory:"})


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'legacy_data'


require 'spec'
require 'spec/autorun'

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
                                  {:generator=>generator_name, :command=>:create, :destination=>RAILS_ROOT}
                                 )    
end

def command_for_generator(generator_name, args, the_command= :create)
  generator = load_generator(generator_name, args)
  LegacyData::TableClassNameMapper.stub!(:log)    
  cmd = generator.command(the_command)
  cmd.stub!(:logger).and_return(stub('stub').as_null_object)
  cmd
end

def invoke_generator(generator_name, args, the_command= :create)
  cmd = command_for_generator(generator_name, args, the_command)
  cmd.invoke!
end
