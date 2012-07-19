require 'happy/template/haml'

module Happy
  module Template
    def self.new(path)
      Happy::Template::Haml.new(path)
    end
  end
end
