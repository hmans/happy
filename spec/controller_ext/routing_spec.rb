require 'spec_helper'

module Happy
  describe Controller::Routing do
    describe '#path' do
      subject do
        Controller.build do
          route do
            path('foo') { serve! 'bar' }
            path('one', 'two') { serve! 'onetwo' }
            path('hello') do
              path(:name) { serve! "Hello #{params['name']}" }
              serve! "Please provide a name."
            end
            path('number-:num') { serve! "num = #{params['num']}" }
            path('return-value') { 'moo?' }
            path('resource') do
              get { 'GET resource' }
              post { 'POST resource' }
            end
            serve! "root"
          end
        end
      end

      it "routes requests to the specified path to its contained block" do
        response_for { get '/' }.body.should == 'root'
        response_for { get '/foo' }.body.should == 'bar'
      end

      it "renders its block's results if no other #serve! call is made" do
        response_for { get '/return-value' }.body.should == 'moo?'
      end

      it "routes independently from the request method" do
        response_for { post '/foo' }.body.should == 'bar'
      end

      it "supports multiple path parameters" do
        response_for { get '/one' }.body.should == 'onetwo'
        response_for { get '/two' }.body.should == 'onetwo'
      end

      it "routes to the root code if no path matches" do
        response_for { get '/' }.body.should == 'root'
      end

      it "executes the contained serve! call if no sub-paths match" do
        response_for { get '/hello' }.body.should == 'Please provide a name.'
      end

      it "just matches the method if no path name is given" do
        response_for { get '/resource' }.body.should == 'GET resource'
        response_for { post '/resource' }.body.should == 'POST resource'
      end

      it "parses parameters when the provided path is a symbol" do
        response_for { get '/hello/hendrik' }.body.should == 'Hello hendrik'
      end

      it "parses parameters within path names" do
        response_for { get '/number-123' }.body.should == 'num = 123'
      end
    end

    %w(get post put delete).each do |what|
      describe "##{what}" do
        subject { Controller.new }

        it "merely invokes #path with the :method => :#{what} option" do
          subject.should_receive(:path).with('path', :method => what.to_sym)
          subject.send(what, 'path')
        end
      end
    end
  end
end
