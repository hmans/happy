require 'happy/controller/routing'
require 'happy/controller/actions'
require 'happy/controller/rackable'

module Happy
  class Controller
    include Routing
    include Actions
    include Rackable

    attr_reader :options, :env

    delegate :request, :response, :remaining_path, :params, :session,
      :render, :url_for,
      :to => :context

    def initialize(env = {}, options = {}, &blk)
      @env = env
      @options = options

      # Execute block against this instance, allowing the controller to
      # provide a DSL for configuration.
      instance_exec(&blk) if blk
    end

    def perform
      context.with_controller(self) do
        route
      end
    end

  private

    def context
      @env['happy.context'] ||= self.class.context_class.from_env(@env)
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
        context_class.class_exec(&blk)
      end

      def context_class
        Happy::Context
      end

      def build(&blk)
        Class.new(self).tap do |klass|
          klass.instance_eval(&blk) if blk
        end
      end
    end
  end
end
