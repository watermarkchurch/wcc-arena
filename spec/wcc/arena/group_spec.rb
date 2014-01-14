require 'spec_helper'

describe WCC::Arena::Group do
  let(:unit) { WCC::Arena::Group }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end

  describe "#group_members" do

    it "initializes GroupMemberQuery with id and calls it" do
      expect(WCC::Arena::GroupMemberQuery).to receive(:new).with(group_id: 123).and_return(query = double(:query)).once
      expect(query).to receive(:call).and_return(:non_nil)
      group = unit.new(:doc)
      group.stub(:id) { 123 }
      2.times { group.members }
    end

  end
end
