require 'spec_helper'

describe WCC::Arena::Person do
  let(:unit) { WCC::Arena::Person }

  describe "#initialize" do
    subject { unit }

    it "sets all attributes from a hash of arguments" do
      person = unit.new(first_name: "Foo", last_name: "Bar")
      expect(person.first_name).to eq("Foo")
      expect(person.last_name).to eq("Bar")
    end
  end

end
