require 'allowance'

module Happy
  module Extensions
    module Permissions
      module ContextExtensions
        extend ActiveSupport::Concern

        def permissions
          @permissions ||= Allowance::Permissions.new
        end
      end

      module ControllerExtensions
        extend ActiveSupport::Concern

        included do
          delegate :permissions, :to => :context
        end
      end
    end
  end
end

Happy::Context.send(:include, Happy::Extensions::Permissions::ContextExtensions)
Happy::Controller.send(:include, Happy::Extensions::Permissions::ControllerExtensions)
