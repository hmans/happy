module Happy
  module Helpers
    module I18n
      def translate(*args)
        ::I18n.translate(*args)
      end

      def localize(*args)
        ::I18n.localize(*args)
      end
    end
  end
end
