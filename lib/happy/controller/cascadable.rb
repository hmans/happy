module Happy
  class Controller
    module Cascadable
      def method_missing(name, *args, &blk)
        if @parent_controller && @parent_controller.respond_to?(name)
          @parent_controller.send(name, *args, &blk)
        else
          super
        end
      end

      def respond_to?(name)
        super || @parent_controller.try(:respond_to?, name)
      end
    end
  end
end
