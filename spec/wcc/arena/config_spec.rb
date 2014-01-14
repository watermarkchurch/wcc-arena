require 'spec_helper'

describe WCC::Arena::Config do
  describe "default connection" do
    subject { WCC::Arena::Config.new }

    it "should be an instance of Faraday::Connection" do
      expect(subject.connection).to be_a(Faraday::Connection)
    end
  end

  describe "default session" do
    it "should return a session" do
      expect(subject.session).to be_a(WCC::Arena::Session)
    end
  end
end

describe WCC::Arena do
  after(:each) do
    WCC::Arena.instance_variable_set(:@config, nil)
  end

  describe "#config" do
    it "sets to instance of Config" do
      expect(WCC::Arena.config).to be_a(WCC::Arena::Config)
    end

    it "returns the same instance each time" do
      config = WCC::Arena.config
      expect(config).to eq(WCC::Arena.config)
    end
  end

  describe "#configure" do
    it "yields to block with config" do
      block_arg = :block_not_run
      WCC::Arena.configure do |config|
        block_arg = config
      end

      expect(block_arg).to eq(WCC::Arena.config)
    end
  end

end
