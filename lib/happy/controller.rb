require 'happy/controller/routing'
require 'happy/controller/actions'
require 'happy/controller/rackable'

module Happy
  class Controller
    include Routing
    include Actions
    include Rackable

    attr_reader :options, :env, :root_path

    delegate :request, :response, :params, :session,
      :previous_path, :remaining_path,
      :render, :url_for,
      :to => :context

    def initialize(env = {}, options = {}, &blk)
      @env = env
      @options = options

      # Save a copy of the current path as this controller's root path.
      @root_path = context.previous_path.dup

      # Execute block against this instance, allowing the controller to
      # provide a DSL for configuration.
      instance_exec(&blk) if blk
    end

    def perform
      context.with_controller(self) do
        route
      end
    end

  protected

    def root_url(extras = nil)
      url_for(root_path, extras)
    end

  private

    def url(extras = nil)
      url_for(previous_path, extras)
    end

    def context
      @env['happy.context'] ||= Happy::Context.from_env(@env)
    end

    def route
      instance_exec(&self.class.route_blk) if self.class.route_blk
    end

    class << self
      attr_reader :route_blk

      def route(&blk)
        @route_blk = blk
      end

      def context(&blk)
        Happy::Context.class_exec(&blk)
      end

      def build(&blk)
        Class.new(self).tap do |klass|
          klass.instance_eval(&blk) if blk
        end
      end
    end
  end
end
