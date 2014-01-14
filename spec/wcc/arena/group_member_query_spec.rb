require 'spec_helper'

describe WCC::Arena::GroupMemberQuery do
  include FixturesHelpers
  let(:unit) { WCC::Arena::GroupMemberQuery }
  let(:args) {
    {
      session: double(:session),
      group_id: 45,
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

    it "sets group_id argument to ivar" do
      obj = subject.new(args)
      expect(obj.group_id).to eq(args[:group_id])
    end

    it "requires a group_id argument" do
      args.delete(:group_id)
      expect { subject.new(args) }.to raise_error(KeyError)
    end

  end

  describe "#call" do
    let(:fixture_response) { xml_fixture_response("group_member_list.xml") }

    it "does a get request to the member list group service" do
      expect(subject.session).to receive(:get).with("group/45/member/list").and_return(fixture_response)
      subject.()
    end

    it "returns an array of GroupMember objects" do
      subject.session.stub(:get) { fixture_response }
      list = subject.()
      list.each do |item|
        expect(item).to be_a(WCC::Arena::GroupMember)
      end
    end
  end
end
