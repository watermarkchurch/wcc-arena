require 'spec_helper'

describe WCC::Arena::GroupMember do
  include FixturesHelpers

  let(:unit) { WCC::Arena::GroupMember }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end

  describe "#person_guid" do
    let(:response) { xml_fixture_response("group_member_list.xml") }
    subject { unit.new(response.xml.root.xpath("//GroupMember").first) }

    it "extracts the guid from the person_link field" do
      expect(subject.person_guid).to_not be_nil
      expect(subject.person_guid).to eq("9ca76a89-2ecf-4b86-b65e-4da822701ecb")
    end
  end

end

