module Happy
  class Static < Happy::Controller
    def route
      run Rack::File.new(options[:path])
    end
  end
end
