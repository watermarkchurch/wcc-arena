require 'spec_helper'

describe WCC::Arena::GroupQuery do
  include FixturesHelpers
  let(:unit) { WCC::Arena::GroupQuery }
  let(:args) {
    {
      session: double(:session),
      person_id: 45,
      category_id: 1,
    }
  }
  subject { unit.new(args) }

  describe "#initialize" do
    subject { unit }
    it "sets @session from args" do
      obj = subject.new(args)
      expect(obj.session).to eq(args[:session])
    end

    it "defaults to global config session when none passed" do
      args.delete(:session)
      obj = subject.new(args)
      expect(obj.session).to eq(WCC::Arena.config.session)
    end

    it "requires a person_id argument" do
      args.delete(:person_id)
      expect { subject.new(args) }.to raise_error(KeyError)
    end

    it "requires a category_id argument" do
      args.delete(:category_id)
      expect { subject.new(args) }.to raise_error(KeyError)
    end
  end

  describe "#call" do
    let(:fixture_response) { xml_fixture_response("person_group_list.xml") }
    let(:list) { subject.() }

    it "does a get request to the person group list service" do
      expect(subject.session).to receive(:get).with("person/45/group/list", categoryid: 1).and_return(fixture_response)
      list
    end

    it "returns an array of Group objects" do
      subject.session.stub(:get) { fixture_response }
      list.each do |item|
        expect(item).to be_a(WCC::Arena::Group)
      end
    end

    it "excludes deleted groups" do
      subject.session.stub(:get) { fixture_response }
      expect(list.map(&:leader_id)).to_not include(-1)
    end
  end
end
