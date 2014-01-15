require 'spec_helper'

describe WCC::Arena::Profile do
  let(:unit) { WCC::Arena::Profile }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end

  describe "#children" do

    it "initializes ProfileQuery with id and calls it" do
      expect(WCC::Arena::ProfileQuery).to receive(:new).with(parent_profile_id: 123).and_return(query = double(:query)).once
      expect(query).to receive(:call).and_return(:non_nil)
      group = unit.new(:doc)
      group.stub(:id) { 123 }
      2.times { group.children }
    end

  end
end
