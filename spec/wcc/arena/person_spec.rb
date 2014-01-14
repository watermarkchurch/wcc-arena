require 'spec_helper'

describe WCC::Arena::Person do
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

end
