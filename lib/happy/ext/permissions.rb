require 'allowance'

module Happy
  module Extensions
    module Permissions
      module ContextExtensions
        extend ActiveSupport::Concern

        def permissions(&blk)
          (@permissions ||= Allowance::Permissions.new).tap do |p|
            if blk
              blk.arity == 0 ? p.instance_exec(&blk) : blk.call(p)
            end
          end
        end

        alias_method :can, :permissions
      end

      module ControllerExtensions
        extend ActiveSupport::Concern

        included do
          delegate :permissions, :can, :to => :context
        end
      end
    end
  end
end

Happy::Context.send(:include, Happy::Extensions::Permissions::ContextExtensions)
Happy::Controller.send(:include, Happy::Extensions::Permissions::ControllerExtensions)
