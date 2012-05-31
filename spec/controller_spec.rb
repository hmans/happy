require 'spec_helper'

module Happy
  describe Controller do
    describe ".build" do
      subject do
        Controller.build do
          route { serve! "yay!" }
        end
      end

      def app
        subject
      end

      it "creates a new controller class" do
        subject.ancestors.should include(Controller)
      end

      it "should use the passed block to initialize the new controller class" do
        get "/"
        last_response.body.should == 'yay!'
      end
    end

    it "is also a Rack app" do
      def app
        Controller.build do
          route do
            serve! "it works"
          end
        end
      end

      get '/'
      last_response.body.should == 'it works'
    end

  end
end
