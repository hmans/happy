require 'happy/template/base'
require 'sass'

module Happy
  module Template
    class Sass < Base
      def setup
        @engine = ::Sass::Engine.new(@source)
      end

      def render(scope = nil, locals = {}, &blk)
        @engine.render
      end
    end
  end
end
