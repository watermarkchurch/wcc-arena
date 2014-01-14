require 'spec_helper'

describe WCC::Arena::Group do
  let(:unit) { WCC::Arena::Group }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end
end
