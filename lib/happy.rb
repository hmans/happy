require 'rack'

# Happy is currently making use of ActiveSupport. I'm not 100% happy
# about this dependency and will eventually try to remove it.
# The following line should at least make sure that the individual
# components are autoloaded as needed.
require 'active_support'

require 'happy/version'
require 'happy/errors'
require 'happy/helpers'
require 'happy/controller'

module Happy
  def self.env
    ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
  end

  # Creates a new Happy::Controller class, using the provided block as
  # its routing block.
  #
  def self.route(&blk)
    Class.new(Happy::Controller).tap do |klass|
      klass.send(:define_method, :route, &blk)
    end
  end
end
