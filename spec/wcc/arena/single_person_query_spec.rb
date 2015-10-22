require 'spec_helper'

describe WCC::Arena::SinglePersonQuery do
  include FixturesHelpers

  subject { described_class.new(args) }
  let(:args) {
    {
      session: double("session"),
      person_id: rand(100)
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

    it "requires a person_id argument" do
      args.delete(:person_id)
      expect { described_class.new(args) }.to raise_error(KeyError)
    end
  end

  describe "#call" do
    let(:fixture_response) { xml_fixture_response("person.xml") }

    it "makes a get request to /person/list with query params" do
      expect(subject.session).to receive(:get)
        .with("person/#{subject.person_id}").and_return(fixture_response)
      subject.()
    end

    it "returns a single Person object" do
      subject.session.stub(:get) { fixture_response }
      record = subject.()
      expect(record).to be_a(WCC::Arena::Person)
      expect(record.first_name).to eq("Donald")
      expect(record.last_name).to eq("Duck")
    end
  end
end
