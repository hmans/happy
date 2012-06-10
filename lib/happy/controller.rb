require 'happy/controller/routing'
require 'happy/controller/actions'
require 'happy/controller/rackable'
require 'happy/controller/configurable'

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

    attr_reader :options, :env, :root_path

    delegate :request, :response, :params, :session,
      :previous_path, :remaining_path,
      :render, :url_for,
      :to => :context

    # Creates a new instance of {Controller}. When a block is provided,
    # it is run against the new instance, allowing custom controller classes
    # to provide DSL-like configuration.
    #
    # @param env [Hash]
    #   Rack environment hash.
    # @param options [Hash]
    #   Controller options.
    #
    def initialize(env = {}, options = {}, &blk)
      @env = env
      @options = options

      # Save a copy of the current path as this controller's root path.
      @root_path = context.previous_path.dup

      # Execute block against this instance, allowing the controller to
      # provide a DSL for configuration.
      instance_exec(&blk) if blk
    end

  protected

    # Run this controller, performing its routing logic.
    #
    def perform
      context.with_controller(self) do
        route
      end
    end

    def root_url(extras = nil)
      url_for(root_path, extras)
    end

  private

    def url(extras = nil)
      url_for(previous_path, extras)
    end

    def context
      @env['happy.context'] ||= Happy::Context.new(@env)
    end

    def route
      # override this in subclasses
    end

  end
end
