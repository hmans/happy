require 'spec_helper'

module Happy
  describe Request do
    describe '#params' do
      subject do
        Happy.route do
          on('symbol') { "Your name is #{params[:name]}!" }
          on('string') { "Your name is #{params['name']}!" }
        end
      end

      it "is accessible through strings" do
        response_for { get '/string', 'name' => 'Hendrik' }.body.should == 'Your name is Hendrik!'
      end

      it "is accessible through symbols" do
        response_for { get '/symbol', 'name' => 'Hendrik' }.body.should == 'Your name is Hendrik!'
      end
    end
  end
end
