module Happy
  class Response < Rack::Response
    attr_accessor :layout

    def initialize(*args)
      super
      @layout = nil
    end
  end
end
