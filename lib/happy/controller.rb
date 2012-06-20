require 'happy/request'
require 'happy/response'

require 'happy/controller/routing'
require 'happy/controller/actions'
require 'happy/controller/rackable'
require 'happy/controller/configurable'
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
    include Permissions
    include Happy::Helpers

    attr_reader :env

    CASCADING_SETTINGS = [:views]

    # Creates a new instance of {Controller}. When a block is provided,
    # it is run against the new instance, allowing custom controller classes
    # to provide DSL-like configuration.
    #
    # @param env_or_parent [Hash,Controller]
    #   Rack environment hash _or_ parent controller.
    # @param opts [Hash]
    #   Options to be merged with the controller's default (class-level) settings.
    #
    def initialize(env_or_parent = {}, opts = {}, &blk)
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

      # Augment this instance's settings hash with the hash given to this constructor
      settings.merge!(opts)

      # Copy missing settings from our parent
      if @parent_controller
        CASCADING_SETTINGS.each do |name|
          settings[name] ||= @parent_controller.settings[name]
        end
      end

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

    attr_reader :unprocessed_path, :processed_path

    def root_url(*extras)
      url_for(@root_url, extras)
    end

    # Returns the application controller (ie, the root controller running this
    # application.)
    #
    def app
      @parent_controller ? @parent_controller.app : self
    end

  private

    # Adds helper methods to the base class for all controllers. Use this
    # to define application-level helper methods that you want to have available
    # in all views, even if they're begin rendered by a controller different from
    # your application controller.
    #
    # Modules passed to this method will be included into the base controller class.
    # Example:
    #
    #     helpers MyApp::Helpers
    #
    # Alternatively, you can specify a block that will be executed against the
    # base controller class like this:
    #
    #     helpers do
    #       def my_little_helper
    #         "something useful"
    #       end
    #     end
    #
    def self.helpers(*args, &blk)
      args.flatten.each do |arg|
        case arg
          when Module then Happy::Controller.send(:include, arg)
          else raise "Invalid helper specified."
        end
      end

      Happy::Controller.class_exec(&blk) if blk
    end

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
