require 'spec_helper'

describe WCC::Arena::Person do
  let(:unit) { WCC::Arena::Person }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end

end
