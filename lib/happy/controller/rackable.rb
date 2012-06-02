module Happy
  class Controller
    module Rackable
      extend ActiveSupport::Concern

      def call(env)
        @env = env

        catch :done do
          serve! perform

          # If we get here, #serve decided not to serve.
          raise Errors::NotFound
        end

        response
      end

      module ClassMethods
        def call(env)
          new.call(env)
        end
      end
    end
  end
end
