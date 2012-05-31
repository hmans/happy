require 'spec_helper'

module Happy
  describe ControllerExtensions::Actions do
    subject { Controller.new }

    describe '#serve!' do
      def app
        build_controller do
          path('simple') { serve! "Simple response" }
          path('with_headers') { serve! "body { color: red }", :content_type => 'text/css' }
          path('with_status')  { serve! "Not Allowed", :status => 401 }
          path('with_layout')  { serve! "content", :layout => 'layout.erb' }
        end
      end

      it "serves the provided string as the response body" do
        response_for { get '/simple' }.body.should == 'Simple response'
      end

      it "responds with a status code of 200 by default" do
        response_for { get '/simple' }.status.should == 200
      end

      it "sets the response status code to its :status option" do
        response_for { get '/with_status' }.status.should == 401
      end

      it "uses the layout provided through the :layout option" do
        instance = Controller.new
        instance.send(:context).should_receive(:render).with('layout.erb')

        catch(:done) { instance.serve! "content", :layout => 'layout.erb' }
      end

      it "sets extra options as response headers" do
        response_for { get '/with_headers' }['Content-type'].should == 'text/css'
      end
    end

    describe '#redirect!' do
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
        subject.should_receive(:header).with(:content_type, 'text/css')
        subject.content_type 'text/css'
      end
    end

    describe '#layout' do
      it "sets the layout to be used by the current context" do
        subject.send(:context).should_receive(:layout=).with('layout.erb')
        subject.layout 'layout.erb'
      end
    end
  end
end
