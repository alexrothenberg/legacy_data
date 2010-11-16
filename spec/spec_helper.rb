require 'rubygems'
# gem 'rspec'
# require 'spec'
# require 'spec/autorun'

$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'active_record'
# Since Legacy Data depends on Foreigner we need to have an ActiveRecord connection established
ActiveRecord::Base.establish_connection({:adapter=>'sqlite3', :database=> ":memory:"})


$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'legacy_data'


# require 'spec'
# require 'spec/autorun'

### Load the rails generator code
# require 'rails_generator'
# require 'rails_generator/scripts'
# require 'rails_generator/scripts/generate'

require 'active_support'
require 'rails/generators'



## Can we turn this into an rspec-rails GeneratorExampleGroup ??????
module GeneratorSpecHelper
  attr_accessor :destination_root
  def generator_class
    self.class.describes
  end

  # You can provide a configuration hash as second argument. This method returns the output
  # printed by the generator.
  def generator(args=generator.default_arguments, options={}, config={})  
    generator_class.new(args, options, config.reverse_merge(:destination_root => destination_root))
  end
  
  def run_generator(args=generator.default_arguments, options={}, config={})  
    capture(:stdout) {
      generator(args, options, config).invoke_all
    }
  end

  # Captures the given stream and returns it:
  #
  #   stream = capture(:stdout){ puts "Cool" }
  #   stream # => "Cool\n"
  #
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
end
