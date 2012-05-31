require 'allowance'

module Happy
  module Extensions
    module Permissions
      module ContextExtensions
        extend ActiveSupport::Concern

        def permissions(&blk)
          @permissions ||= Allowance.define
        end

        def can?(*args)
          permissions.allowed?(*args)
        end
      end

      module ControllerExtensions
        extend ActiveSupport::Concern

        included do
          delegate :can?, :to => :context
        end

        module ClassMethods
          attr_accessor :permissions_blk

          def permissions(&blk)
            self.permissions_blk = blk
          end
        end
      end
    end
  end
end

Happy::Context.send(:include, Happy::Extensions::Permissions::ContextExtensions)
Happy::Controller.send(:include, Happy::Extensions::Permissions::ControllerExtensions)
