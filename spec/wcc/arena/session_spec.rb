require 'spec_helper'
require 'ostruct'

describe WCC::Arena::Session do
  let(:unit) { WCC::Arena::Session }
  subject { unit.new(args) }

  let(:args) {
    {
      username: "user",
      password: "pass",
      api_key: "api-key",
      api_secret: "api-secret",
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
    subject { unit }

    it "accepts credentials and sets appropriate values" do
      session = subject.new(args.merge(connection: :value))

      expect(session.username).to eq("user")
      expect(session.password).to eq("pass")
      expect(session.api_key).to eq("api-key")
      expect(session.api_secret).to eq("api-secret")
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
      expect { subject.new(args.reject {|k,v| k == :api_secret }) }.to raise_error(KeyError)
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
    subject { unit.new(args.merge(connection: login_stub(login_failed_body))) }
    describe "data accessors" do
      it "return nil" do
        expect(subject.id).to be_nil
        expect(subject.expires).to be_nil
      end
    end
  end

  describe "connection wrapper methods" do
    subject { unit.new(args.merge(connection: connection_stub(signed, verb, "poop"))) }
    let(:signed) { signed_path("test", "id", "api-secret") }
    before(:each) do
      subject.stub(:id) { "id" }
    end

    describe "#get" do
      let(:verb) { :get }

      it "calls get on connection with signed version of path argument" do
        expect(subject.connection).to receive(:get).with(signed).and_return(OpenStruct.new)
        subject.get("test")
      end

      it "returns a Response object" do
        response = subject.get("test")
        expect(response).to be_a(WCC::Arena::Response)
        expect(response.status).to eq(200)
        expect(response.body).to eq("poop")
      end
    end

    describe "#post" do
      let(:verb) { :post }

      it "calls post on connection with signed version of path argument" do
        expect(subject.connection).to receive(:post).with(signed).and_return(OpenStruct.new)
        subject.post("test")
      end

      it "returns a Response object" do
        response = subject.post("test")
        expect(response).to be_a(WCC::Arena::Response)
        expect(response.status).to eq(200)
        expect(response.body).to eq("poop")
      end
    end
  end

  def signed_path(path, id, secret)
    WCC::Arena::SignedPath.new(
      path: path,
      session_id: id,
      api_secret: secret
    ).()
  end

  def login_stub(body)
    connection_stub("login", :post, body)
  end

  def connection_stub(path, method=:get, body="")
    Faraday.new(url: "http://test") do |builder|
      builder.adapter :test do |stub|
        stub.public_send(method, path) { [200, { "content-type" => "application/xml" }, body] }
      end
    end
  end

end
