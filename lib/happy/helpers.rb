require 'happy/helpers/html'
require 'happy/helpers/i18n'
require 'happy/helpers/rendering'

module Happy
  # A collection of useful helper methods.
  #
  module Helpers
    include Html
    include Rendering
    include I18n

    # Some useful shortcuts.
    #
    alias_method :h, :escape_html
    alias_method :l, :localize
    alias_method :t, :translate
  end
end
