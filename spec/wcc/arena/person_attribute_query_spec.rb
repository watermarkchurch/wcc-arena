require 'spec_helper'

describe WCC::Arena::PersonAttributeQuery do
  include FixturesHelpers
  subject { unit.new(args) }
  let(:unit) { WCC::Arena::PersonAttributeQuery }
  let(:args) {
    {
      session: double("session"),
      person_id: 123,
    }
  }

  describe "#initialize" do
    subject { unit }
    it "sets the session ivar" do
      query = subject.new(args)
      expect(query.session).to eq(args[:session])
    end

    it "defaults session to global config value" do
      args.delete(:session)
      query = subject.new(args)
      expect(query.session).to eq(WCC::Arena.config.session)
    end

    it "sets person_id to required :person_id value" do
      query = subject.new(args)
      expect(query.person_id).to eq(123)
      args.delete(:person_id)
      expect { subject.new(args) }.to raise_error(KeyError)
    end
  end

  describe "#call" do
    let(:fixture_response) { xml_fixture_response("person_attribute_list.xml") }

    it "makes a get request to /person/:person_id/attribute/list with query params" do
      expect(subject.session).to receive(:get).with("person/123/attribute/list").and_return(fixture_response)
      subject.()
    end

    it "returns a list of PersonAttributeGroup objects built from the returned records" do
      subject.session.stub(:get) { fixture_response }
      records = subject.()
      expect(records.size).to eq(1)
      expect(records.first).to be_a(WCC::Arena::PersonAttributeGroup)
      expect(records.first.id).to eq(3)
      expect(records.first.name).to eq("Member Path")
    end
  end

end
