require 'happy/template/sass'

module Happy
  module Template
    class Scss < Sass
      def setup
        @engine = ::Sass::Engine.new(@source, :syntax => :scss)
      end
    end
  end
end
