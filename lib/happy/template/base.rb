module Happy
  module Template
    class Base
      def initialize(path)
        @path = path
        load_source
        setup
      end

      def load_source
        @source = File.read(@path)
      end

      def setup
      end

      def render(scope = nil, locals = {}, &blk)
        raise "not implemented"
      end
    end
  end
end
