require 'spec_helper'
require 'cgi'

describe WCC::Arena::SignedPath do
  subject { WCC::Arena::SignedPath.new(args) }
  let(:args) {
    {
      path: "Foo/",
      session_id: "session-id",
      api_secret: "api-secret",
    }
  }

  describe "#initialize" do
    subject { WCC::Arena::SignedPath }
    it "sets instance vars from arguments" do
      request = subject.new(args)
      expect(request.path).to eq(args[:path])
      expect(request.session_id).to eq(args[:session_id])
      expect(request.api_secret).to eq(args[:api_secret])
    end

    it "raises errors with missing required arguments" do
      expect { subject.new(args.reject { |k,v| k == :path }) }.to raise_error(KeyError)
      expect { subject.new(args.reject { |k,v| k == :session_id }) }.to raise_error(KeyError)
      expect { subject.new(args.reject { |k,v| k == :api_secret }) }.to raise_error(KeyError)
    end
  end

  describe "#path_with_session" do
    it "attaches the session_id as api_session attribute" do
      expect(subject.path_with_session).to match("api_session=session-id")
    end
  end

  describe "#api_sig" do
    it "is an md5 hash of secret and path_with_session" do
      digest = Digest::MD5.hexdigest("api-secret_foo/&api_session=session-id")
      expect(subject.api_sig).to eq(digest)
    end
  end

  describe "#call" do
    it "appends api_sig value" do
      expect(subject.()).to match("api_sig=#{subject.api_sig}")
    end

    it "includes api_session" do
      expect(subject.()).to match("api_session=session-id")
    end

    it "include the base path" do
      expect(subject.()).to match(/^#{subject.path}/)
    end

    it "concats everything in a parsable manner" do
      args = CGI.parse(subject.())
      expect(args["api_sig"][0]).to eq(subject.api_sig)
      expect(args["api_session"][0]).to eq(subject.session_id)
    end
  end

  def fake_connection
    Faraday.new(url: "http://test.com") do |builder|
      builder.adapter :test
    end
  end
end
