require 'spec_helper'

describe WCC::Arena::Person do
  include FixturesHelpers
  let(:unit) { WCC::Arena::Person }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end

  describe "#member?" do
    it "returns true only when member_status_id matches IS_MEMBER_STATUS_ID" do
      obj = unit.new(:foo)
      obj.stub(:member_status_id) { unit::IS_MEMBER_STATUS_ID }
      expect(obj.member?).to be_true
      obj.stub(:member_status_id) { 0 }
      expect(obj.member?).to be_false
    end
  end

  describe "#groups" do

    it "initializes GroupQuery with id and default category and calls it" do
      expect(WCC::Arena::GroupQuery).to receive(:new).with(person_id: 123, category_id: 1).and_return(query = double(:query)).once
      expect(query).to receive(:call).and_return(:non_nil)
      person = unit.new(:doc)
      person.stub(:id) { 123 }
      2.times { person.groups }
    end

  end

  shared_examples "add a profile" do
    subject { unit.new(:doc) }
    before(:each) do
      subject.stub(:id) { 123 }
    end

    it "initializes and calls a ProfileMemberSave" do
      expect(WCC::Arena::ProfileMemberSave).to receive(:new).with(person_id: 123, profile_id: 456).and_return(query = double(:query))
      expect(query).to receive(:call)
      subject.public_send(method_name, 456)
    end
  end

  describe "#add_profile" do
    it_behaves_like "add a profile" do
      let(:method_name) { :add_profile }
    end
  end

  describe "#add_tag" do
    it_behaves_like "add a profile" do
      let(:method_name) { :add_tag }
    end
  end

end
