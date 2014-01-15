require 'spec_helper'

describe WCC::Arena::ProfileQuery do
  include FixturesHelpers
  let(:unit) { WCC::Arena::ProfileQuery }
  let(:args) {
    {
      session: double(:session),
      profile_type_id: 1,
    }
  }
  subject { unit.new(args) }

  describe "#initialize" do
    subject { unit }
    let(:instance) {
      subject.new(args)
    }

    it "sets @session from args" do
      expect(instance.session).to eq(args[:session])
    end

    it "defaults to global config session when none passed" do
      args.delete(:session)
      expect(instance.session).to eq(WCC::Arena.config.session)
    end

    it "sets :profile_type_id to @profile_type_id" do
      expect(instance.profile_type_id).to eq(args[:profile_type_id])
    end

    it "sets :parent_profile_id arg to @parent_profile_id" do
      args.delete(:profile_type_id)
      args[:parent_profile_id] = 123
      expect(instance.parent_profile_id).to eq(123)
    end

    it "requires either :profile_type_id or :profile to be set but not both" do
      args.delete(:profile_type_id)
      expect { instance.profile }.to raise_error(ArgumentError)
      expect { subject.new(args.merge(profile_type_id: 1, parent_profile_id: 123)) }.to raise_error(ArgumentError)
    end

  end

  describe "#call" do
    let(:list_response) { xml_fixture_response("profile_list.xml") }

    it "does a get request to the person group list service" do
      expect(subject.session).to receive(:get).with("profile/list", profiletype: 1).and_return(list_response)
      subject.()
    end

    it "calls with the parent_profile_id if that is provided" do
      args.delete(:profile_type_id)
      args[:parent_profile_id] = 123
      expect(subject.session).to receive(:get).with("profile/123/list", {}).and_return(list_response)
      subject.()
    end

    it "returns an array of Profile objects with list response" do
      subject.session.stub(:get) { list_response }
      list = subject.()
      expect(list).to_not be_empty
      list.each do |item|
        expect(item).to be_a(WCC::Arena::Profile)
      end
    end

    it "ignores nil entries" do
      subject.session.stub(:get) { list_response }
      expect(subject.().collect(&:id)).to_not include(nil)
    end

  end
end
