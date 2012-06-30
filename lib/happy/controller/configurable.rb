module Happy
  class Controller
    module Configurable
      def self.included(base)
        base.extend ClassMethods
      end

      # Return a hash containing this controller instance's settings.
      #
      def settings
        @settings ||= self.class.settings.dup
      end

      # Change a setting on this controller instance.
      #
      def set(k, v)
        settings[k.to_sym] = v
      end

      module ClassMethods
        # Return a hash containing this controller class' default settings.
        #
        def settings
          @settings ||= {}
        end

        # Change a default setting on this controller class.
        #
        def set(k, v)
          settings[k.to_sym] = v
        end
      end
    end
  end
end
