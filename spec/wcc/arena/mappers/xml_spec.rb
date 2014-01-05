require 'spec_helper'

describe WCC::Arena::Mappers::XML do
  let(:unit) { WCC::Arena::Mappers::XML }
  subject { Class.new }
  before(:each) { subject.send(:include, unit) }

  let(:xml_fixture_path) { File.join(FIXTURES_DIR, 'person.xml') }
  let(:xml) { File.open(xml_fixture_path) { |f| f.read } }
  let(:doc) { Nokogiri::XML.parse(xml) }

  describe "#initialize" do
    it "takes an xml document and sets it to @document" do
      obj = subject.new(:doc)
      expect(obj.document).to eq(:doc)
    end
  end

  describe "#[]" do
    before(:each) do
      subject.attribute :first_name, xpath: "Person/FirstName"
      subject.attribute :last_name, xpath: "Person/WrongPath"
    end
    let(:person) { subject.new(doc) }

    it "returns the value for the given attribute name" do
      expect(person[:first_name]).to eq("Donald")
    end

    it "returns nil when the element is not found" do
      expect(person[:last_name]).to be_nil
    end

    it "raises a KeyError when the field is not defined" do
      expect { person[:undefined] }.to raise_error(KeyError)
    end

  end

  describe "::attribute" do
    let(:fake_options) { { xpath: "Foo" } }

    it "stores data in a @attributes class attribute hash" do
      subject.attribute :foo, fake_options
      expect(subject.attributes).to eq({ foo: fake_options })
    end

    it "requires :xpath option" do
      expect { subject.attribute :foo, {} }.to raise_error(ArgumentError)
    end

    it "defines a method for the key that delegates to the index method" do
      subject.attribute :foo, fake_options
      obj = subject.new(:doc)
      expect(obj).to respond_to(:foo)
      expect(obj).to receive(:[]).with(:foo)
      obj.foo
    end

    it "freezes the options" do
      subject.attribute :foo, fake_options
      expect { subject.attributes[:foo][:bar] = "test" }.to raise_error
    end

    it "flows down the class hierarchy" do
      subject.attribute :foo, fake_options
      subclass = Class.new(subject)
      expect(subclass.attributes).to eq(subject.attributes)
      subclass.attribute :bar, fake_options
      expect(subclass.attributes).to_not eq(subject.attributes)
    end
  end

end

