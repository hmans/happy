module Happy
  class Controller
    module Configurable
      extend ActiveSupport::Concern

      def options
        @options ||= self.class.options.dup
      end

      def set(k, v)
        options[k.to_sym] = v
      end

      module ClassMethods
        def options
          @options ||= {}
        end

        def set(k, v)
          options[k.to_sym] = v
        end
      end
    end
  end
end
