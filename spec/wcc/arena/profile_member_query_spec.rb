require 'spec_helper'

describe WCC::Arena::ProfileMemberQuery do
  include FixturesHelpers
  let(:unit) { WCC::Arena::ProfileMemberQuery }
  let(:args) {
    {
      session: double(:session),
      profile_id: 45,
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

    it "sets profile_id argument to ivar" do
      obj = subject.new(args)
      expect(obj.profile_id).to eq(args[:profile_id])
    end

    it "requires a profile_id argument" do
      args.delete(:profile_id)
      expect { subject.new(args) }.to raise_error(KeyError)
    end

  end

  describe "#call" do
    let(:fixture_response) { xml_fixture_response("profile_member_list.xml") }

    it "does a get request to the member list profile service" do
      expect(subject.session).to receive(:get).with("profile/45/member/list", fields: "personid").and_return(fixture_response)
      subject.()
    end

    it "returns an array of ProfileMember objects" do
      subject.session.stub(:get) { fixture_response }
      list = subject.()
      list.each do |item|
        expect(item).to be_a(WCC::Arena::ProfileMember)
      end
    end
  end
end
