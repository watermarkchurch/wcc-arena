require 'spec_helper'

describe WCC::Arena::Session do
  subject { WCC::Arena::Session.new(args) }

  let(:args) {
    {
      username: "user",
      password: "pass",
      api_key: "api-key",
      connection: login_stub(login_success_body)
    }
  }
  let(:stub_date_expires) { "2013-12-20T14:46:43.8810288-06:00" }
  let(:stub_session_id) { "5hbgn91u-31ha-4253-9818-712232a47583" }
  let(:login_success_body) {
    "<ApiSession xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\"><DateExpires>#{stub_date_expires}</DateExpires><SessionID>#{stub_session_id}</SessionID></ApiSession>"
  }
  let(:login_failed_body) {
    "<Error><StatusCode>403</StatusCode><Message>Invalid person id -1</Message></Error>"
  }

  describe "#initializer" do
    subject { WCC::Arena::Session }

    it "accepts credentials and sets appropriate values" do
      session = subject.new(args.merge(connection: :value))

      expect(session.username).to eq("user")
      expect(session.password).to eq("pass")
      expect(session.api_key).to eq("api-key")
      expect(session.connection).to eq(:value)
    end

    it "defaults connection to global config's connection" do
      session = subject.new(args.reject { |k,v| k == :connection })
      expect(session.connection).to eq(WCC::Arena.config.connection)
    end

    it "fails if any value is not passed in" do
      expect { subject.new(args.reject {|k,v| k == :username }) }.to raise_error(KeyError)
      expect { subject.new(args.reject {|k,v| k == :password }) }.to raise_error(KeyError)
      expect { subject.new(args.reject {|k,v| k == :api_key }) }.to raise_error(KeyError)
    end
  end

  context "with good credentials" do
    describe "#id" do
      it "returns the SessionID from the credentialing API call" do
        expect(subject.id).to eq(stub_session_id)
      end
    end

    describe "#expires" do
      it "returns the DateExpires from the credentialing API call" do
        expect(subject.expires).to eq(Time.parse(stub_date_expires))
      end
    end
  end

  context "with bad credentials" do
    subject { WCC::Arena::Session.new(args.merge(connection: login_stub(login_failed_body))) }
    describe "data accessors" do
      it "return nil" do
        expect(subject.id).to be_nil
        expect(subject.expires).to be_nil
      end
    end
  end

  def login_stub(body)
    Faraday.new(url: "http://test") do |builder|
      builder.adapter :test do |stub|
        stub.post("login") { [200, {}, body] }
      end
    end
  end

end
