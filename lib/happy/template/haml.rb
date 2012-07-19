require 'happy/template/base'
require 'haml'

module Happy
  module Template
    class Haml < Base
      def setup
        @engine = ::Haml::Engine.new(@source)
      end

      def render(scope = nil, locals = {}, &blk)
        @engine.render(scope, locals, &blk)
      end
    end
  end
end
