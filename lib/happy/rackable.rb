module Happy
  module Rackable
    extend ActiveSupport::Concern

    def call(env)
      @env = env

      catch :done do
        serve! perform

        # If we get here, #serve decided not to serve.
        raise NotFoundError
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
