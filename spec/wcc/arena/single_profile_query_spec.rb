require 'spec_helper'

RSpec.describe WCC::Arena::SingleProfileQuery do
  include FixturesHelpers

  subject { described_class.new(args) }
  let(:args) {
    {
      session: double("session"),
      profile_id: rand(100)
    }
  }

  describe "#initialize" do
    it "sets the session ivar" do
      query = described_class.new(args)
      expect(query.session).to eq(args[:session])
    end

    it "defaults session to global config value" do
      args.delete(:session)
      query = described_class.new(args)
      expect(query.session).to eq(WCC::Arena.config.session)
    end

    it "requires a profile_id argument" do
      args.delete(:profile_id)
      expect { described_class.new(args) }.to raise_error(KeyError)
    end
  end

  describe "#call" do
    let(:fixture_response) { xml_fixture_response("profile.xml") }

    it "makes a get request to /profile/:profile_id with query params" do
      expect(subject.session).to receive(:get)
        .with("profile/#{subject.profile_id}").and_return(fixture_response)
      subject.()
    end

    it "returns a single Profile object" do
      subject.session.stub(:get) { fixture_response }
      record = subject.()
      expect(record).to be_a(WCC::Arena::Profile)
      expect(record.name).to eq("Awesome")
      expect(record.active_members).to eq(31699)
    end

    it "returns nil when profile not found" do
      subject.session
        .stub(:get) { xml_fixture_response("person_not_found.xml") }
      expect(subject.()).to be_nil
    end
  end
end
