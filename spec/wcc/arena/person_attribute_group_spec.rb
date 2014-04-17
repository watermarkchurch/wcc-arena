require 'spec_helper'

describe WCC::Arena::PersonAttributeGroup do
  include FixturesHelpers
  let(:unit) { WCC::Arena::PersonAttributeGroup }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end
end
