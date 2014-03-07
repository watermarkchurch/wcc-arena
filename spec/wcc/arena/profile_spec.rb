require 'spec_helper'

describe WCC::Arena::Profile do
  let(:unit) { WCC::Arena::Profile }
  subject { unit.new(:doc) }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end

  describe "#children" do

    it "initializes ProfileQuery with id and calls it" do
      expect(WCC::Arena::ProfileQuery).to receive(:new).with(parent_profile_id: 123).and_return(query = double(:query)).once
      expect(query).to receive(:call).and_return(:non_nil)
      subject.stub(:id) { 123 }
      2.times { subject.children }
    end

  end

  describe "#members" do

    it "builds a ProfileMemberQuery with id and calls it returning the result" do
      query = double(:profile_member_query)
      expect(WCC::Arena::ProfileMemberQuery).to receive(:new).with(profile_id: 123).and_return(query).once
      expect(query).to receive(:call).and_return(:value)
      subject.stub(:id) { 123 }
      2.times { subject.members }
    end

  end
end
