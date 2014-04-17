require 'spec_helper'

describe WCC::Arena::PersonAttribute do
  include FixturesHelpers
  let(:unit) { WCC::Arena::PersonAttribute }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end
end
