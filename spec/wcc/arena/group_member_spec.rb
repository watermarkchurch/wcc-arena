require 'spec_helper'

describe WCC::Arena::GroupMember do
  let(:unit) { WCC::Arena::GroupMember }

  it "includes Mappers::XML" do
    expect(unit.ancestors).to include(WCC::Arena::Mappers::XML)
  end

end

