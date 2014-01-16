require 'spec_helper'

describe WCC::Arena::ModifyResult do
  include FixturesHelpers
  let(:unit) { WCC::Arena::ModifyResult }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end

  context "successful result" do
    let(:success) { xml_fixture_response("modify_result_success.xml") }
    subject { unit.new(success.xml.root) }
    it "returns true for successful" do
      expect(subject.successful).to be_true
    end
  end

  context "failure result" do
    let(:failure) { xml_fixture_response("modify_result_failure.xml") }
    subject { unit.new(failure.xml.root) }

    it "returns true for successful" do
      expect(subject.successful).to be_false
    end

    it "maps the error_message" do
      expect(subject.error_message).to_not be_empty
    end
  end


end
