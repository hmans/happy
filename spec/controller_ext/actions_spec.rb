require 'spec_helper'

module Happy
  describe ControllerExtensions::Actions do
    subject { Controller.new }

    describe '#header' do
      it "sets the specified header in the response" do
        subject.send(:context).response.should_receive(:[]=).with('Content-type', 'text/css')
        subject.header 'Content-type', 'text/css'
      end

      it "also accepts the header name as a symbol" do
        subject.send(:context).response.should_receive(:[]=).with('Content-type', 'text/css')
        subject.header :content_type, 'text/css'
      end
    end

    describe '#content_type' do
      it "sets the Content-type header" do
        subject.should_receive(:header).with('Content-type', 'text/css')
        subject.content_type 'text/css'
      end
    end

    describe 'redirect!' do
      it "triggers a redirection to the specified URL" do
        def app
          build_controller { redirect! 'http://www.test.com' }
        end

        get '/'
        last_response.status.should == 302
        last_response.headers['Location'].should == 'http://www.test.com'
      end

      it "sets the provided status code" do
        def app
          build_controller { redirect! 'http://www.test.com', 301 }
        end

        get '/'
        last_response.status.should == 301
      end
    end
  end
end
