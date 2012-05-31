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
  end
end
