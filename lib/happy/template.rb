require 'happy/template/haml'

module Happy
  module Template
    def self.new(path)
      Happy::Template::Haml.new(path)
    end

    def self.available_engines
      ['erb', 'haml']
    end

    def self.discover(path, name, format = 'html')
      # exact match found?
      full_name = File.expand_path(File.join(path, name))
      return full_name if File.exist?(full_name)

      # search for known engines
      split_name = name.split('.')
      if !available_engines.include?(split_name.last)
        available_engines.each do |engine|
          f = discover(path, "#{name}.#{engine}")
          return f if f
        end
      end

      # search for name including format
      if split_name.size == 1
        f = discover(path, "#{name}.#{format}", nil)
        return f if f
      end

      # give up
      false
    end
  end
end
