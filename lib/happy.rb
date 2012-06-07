require 'rack'
require 'happy/version'
require 'happy/context'
require 'happy/controller'

module Happy
  module Errors
    class Base < StandardError ; end
    class NotFound < Base ; end
  end

  def self.env
    ActiveSupport::StringInquirer.new(ENV['RACK_ENV'] || 'development')
  end

  # Creates a new Happy::Controller class, using the provided block as
  # its routing block.
  #
  def self.route(&blk)
    @last_controller_class_created = Class.new(Happy::Controller).tap do |klass|
      klass.send(:define_method, :route, &blk)
    end
  end

  # Run the provided block against Happy::Context. Use this to add new
  # methods to the request context class.
  #
  def self.context(&blk)
    Context.class_exec(&blk)
  end

  def self.call(env)
    @last_controller_class_created.try(:call, env) or raise "Please use Happy.route to define some routes."
  end
end
