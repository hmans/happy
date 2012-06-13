require 'spec_helper'

module Happy
  describe Controller::Cascadable do

    describe '#method_missing' do
      it "passes on all method calls to a parent if there is one" do
        class Inner < Controller
          def route
            path? 'one' do
              some_helper
            end

            path? 'two' do
              some_unknown_helper
            end
          end
        end

        class Middle < Controller
          def route
            run Inner
          end
        end

        class Outer < Controller
          def some_helper; 'some_information'; end
          def route
            run Middle
          end
        end

        def app
          Outer
        end

        response_for { get '/one' }.body.should == 'some_information'
        response_for { get '/two' }.status.should == 500
      end
    end

  end
end
