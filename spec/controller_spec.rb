require 'spec_helper'

module Happy
  describe Controller do
    subject do
      Controller.build do
        route do
          serve! "it works"
        end
      end
    end

    it "is mountable as a Rack app" do
      subject.should respond_to(:call)
      get '/'
      last_response.body.should == 'it works'
    end

    describe ".build" do
      subject do
        Controller.build do
          route { serve! "yay!" }
        end
      end

      it "creates a new controller class" do
        subject.ancestors.should include(Controller)
      end

      it "should use the passed block to initialize the new controller class" do
        get "/"
        last_response.body.should == 'yay!'
      end
    end
  end
end
