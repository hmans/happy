require 'allowance'

module Happy
  class Controller
    module Permissions
      def permissions(&blk)
        (@env['happy.permissions'] ||= Allowance::Permissions.new).tap do |p|
          if blk
            blk.arity == 0 ? p.instance_exec(&blk) : blk.call(p)
          end
        end
      end

      alias_method :can, :permissions
    end
  end
end
