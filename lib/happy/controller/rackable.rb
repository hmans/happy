module Happy
  class Controller
    module Rackable
      extend ActiveSupport::Concern

      def call(env)
        @env = env

        catch :done do
          serve_or_404! perform
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
