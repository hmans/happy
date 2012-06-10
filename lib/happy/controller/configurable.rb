module Happy
  class Controller
    module Configurable
      extend ActiveSupport::Concern

      def config
        self.class.config
      end

      module ClassMethods
        def config
          @config ||= {}
        end

        def set(k, v)
          config[k.to_sym] = v
        end
      end
    end
  end
end
