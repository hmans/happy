require 'happy/request'
require 'happy/response'

require 'happy/controller/helpers'
require 'happy/controller/routing'
require 'happy/controller/actions'
require 'happy/controller/rackable'
require 'happy/controller/configurable'
require 'happy/controller/cascadable'
require 'happy/controller/permissions'

module Happy
  # Base class for Happy controllers. A controller's primary job is to act
  # upon an incoming request, navigating the request URL's path, and finally
  # deciding on a course of action (eg. rendering something, redirecting the
  # client, passing control over to another controller, and so on.)
  #
  class Controller
    include Routing
    include Actions
    include Rackable
    include Configurable
    include Cascadable
    include Permissions
    include Helpers

    attr_reader :env, :unprocessed_path, :processed_path

    # Creates a new instance of {Controller}. When a block is provided,
    # it is run against the new instance, allowing custom controller classes
    # to provide DSL-like configuration.
    #
    # @param env [Hash]
    #   Rack environment hash.
    # @param options [Hash]
    #   Controller options.
    #
    def initialize(env_or_parent = {}, options = {}, &blk)
      if env_or_parent.is_a?(Happy::Controller)
        @parent_controller = env_or_parent
        @env = @parent_controller.env
        @unprocessed_path = env_or_parent.unprocessed_path
        @processed_path = env_or_parent.processed_path
      else
        @env = env_or_parent
        @unprocessed_path = request.path.split('/').reject {|s| s.blank? }
        @processed_path  = []
      end

      self.options.merge(options)

      # Save a copy of the current path as this controller's root path.
      @root_url = processed_path.join('/')

      # Execute block against this instance, allowing the controller to
      # provide a DSL for configuration.
      instance_exec(&blk) if blk
    end

    def request
      @env['happy.request'] ||= Happy::Request.new(@env)
    end

    def response
      @env['happy.response'] ||= Happy::Response.new
    end

  protected

    def root_url(*extras)
      url_for(@root_url, extras)
    end

  private

    def current_url(*extras)
      url_for(processed_path, extras)
    end

    def route
      # override this in subclasses
    end

    def params; request.params; end
    def session; request.session; end

  end
end
