module Happy
  module Utils
    class AppSpawner
      attr_reader :options

      def initialize(options = {})
        @app = nil
        @options = {
          :scripts => './app/*.rb'
        }.merge(options)
      end

      def call(env)
        app.call(env)
      end

      def app
        @app = reload_app? ? load_app : @app
      end

      def load_app
        Happy::Controller.build.tap do |klass|
          Dir[options[:scripts]].each do |file|
            klass.instance_eval File.read(file)
          end
        end
      end

      def reload_app?
        !Happy.env.production? || @app.nil?
      end
    end
  end
end
