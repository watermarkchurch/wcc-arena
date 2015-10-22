require 'spec_helper'

describe WCC::Arena::ProfileMember do
  include FixturesHelpers

  let(:unit) { WCC::Arena::ProfileMember }
  subject { unit.new(:doc) }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end

  context "with real data" do
    let(:response) { xml_fixture_response("profile_member_list.xml") }
    subject { unit.new(response.xml.root.xpath("//ProfileMember").first) }

    describe "#person_guid" do
      it "extracts the guid from the person_link field" do
        expect(subject.person_id).to eq(12345)
      end
    end
  end

  describe "#person method" do
    let(:person_id) { 123 }
    before(:each) do
      subject.stub(:person_id) { person_id }
    end

    it "fetchs builds and executes a SinglePersonQuery on the person_id attribute" do
      expect(WCC::Arena::SinglePersonQuery).to receive(:new).once
        .with(person_id: person_id).and_return(-> { :record })
      expect(subject.person).to eq(:record)
      expect(subject.person).to eq(:record)
    end
  end

end
