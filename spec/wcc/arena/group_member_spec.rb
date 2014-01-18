require 'spec_helper'

describe WCC::Arena::GroupMember do
  include FixturesHelpers

  let(:unit) { WCC::Arena::GroupMember }
  subject { unit.new(:doc) }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end

  context "with real data" do
    let(:response) { xml_fixture_response("group_member_list.xml") }
    subject { unit.new(response.xml.root.xpath("//GroupMember").first) }

    describe "#person_guid" do
      it "extracts the guid from the person_link field" do
        expect(subject.person_guid).to_not be_nil
        expect(subject.person_guid).to eq("9ca76a89-2ecf-4b86-b65e-4da822701ecb")
      end
    end

    describe "#full_name" do
      it "delegates to the person.full_name" do
        subject.person.stub(:full_name) { "hello" }
        expect(subject.full_name).to eq("hello")
      end

      it "concats person.first_name and person.last_name if full_name is null" do
        subject.person.stub(:first_name) { "first" }
        subject.person.stub(:last_name) { "last" }
        expect(subject.full_name).to eq("first last")
      end
    end

  end

end

