require 'happy/template/base'
require 'erb'

module Happy
  module Template
    class Erb < Base
      def setup
        @engine = ::ERB.new(@source)
      end

      def render(scope = nil, locals = {}, &blk)
        @engine.result(scope.send(:binding))
      end
    end
  end
end
