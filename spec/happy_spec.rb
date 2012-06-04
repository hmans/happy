require 'spec_helper'

describe Happy do
  describe '#env' do
    it "is a StringInquirer instance describing the RACK environment" do
      Happy.env.should be_kind_of(ActiveSupport::StringInquirer)
    end

    it "provides #development?, #production? etc." do
      ENV.should_receive(:[]).twice.with('RACK_ENV').and_return('development')
      Happy.env.should be_development
      Happy.env.should_not be_production

      ENV.should_receive(:[]).twice.with('RACK_ENV').and_return('production')
      Happy.env.should be_production
      Happy.env.should_not be_development
    end
  end
end
