require 'happy/routing'
require 'happy/actions'
require 'happy/rackable'

module Happy
  class Controller
    include Routing
    include Actions
    include Rackable

    attr_reader :options, :env

    delegate :request, :response, :remaining_path, :params, :session,
      :render, :url_for,
      :to => :context

    def initialize(env = nil, options = {}, &blk)
      @env = env
      @options = options
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
    end
  end
end
