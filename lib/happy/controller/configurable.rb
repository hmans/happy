module Happy
  class Controller
    module Configurable
      def self.included(base)
        base.extend ClassMethods
      end

      # Return a hash containing this controller instance's settings.
      #
      def settings
        @settings ||= (self.class.settings.nil? ? {} : self.class.settings.dup)
      end

      # Change a setting on this controller instance.
      #
      def set(k, v)
        settings[k.to_sym] = v
      end

      module ClassMethods
        attr_accessor :settings

        # Change a default setting on this controller class.
        #
        def set(k, v)
          self.settings ||= {}
          settings[k.to_sym] = v
        end

        # Make sure inherited classes also get a copy of this class' settings.
        #
        def inherited(subclass)
          subclass.settings = settings.dup unless settings.nil?
        end
      end
    end
  end
end
