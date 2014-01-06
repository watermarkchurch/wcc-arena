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

    it "stores data in a @attributes class ivar hash" do
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
      expect { subject.attributes[:foo][:bar] = "test" }.to raise_error(RuntimeError)
    end

    it "flows down the class hierarchy" do
      subject.attribute :foo, fake_options
      subclass = Class.new(subject)
      expect(subclass.attributes).to eq(subject.attributes)
      subclass.attribute :bar, fake_options
      expect(subclass.attributes).to_not eq(subject.attributes)
    end
  end

  describe "::has_many" do
    let(:fake_args) { { xpath: "foo", klass: "foo" } }

    it "requires xpath option" do
      fake_args.delete(:xpath)
      expect { subject.has_many :foos, fake_args }.to raise_error(ArgumentError)
    end

    it "requires klass option" do
      fake_args.delete(:klass)
      expect { subject.has_many :foos, fake_args }.to raise_error(ArgumentError)
    end

    it "stores data in @associations class ivar hash" do
      subject.has_many :foos, fake_args
      expect(subject.associations[:foos]).to eq(fake_args)
    end

    it "freezes the options" do
      subject.has_many :foos, fake_args
      expect { subject.associations[:foos][:bar] = "test" }.to raise_error(RuntimeError)
    end

    it "flows down the class hierarchy" do
      subject.has_many :foos, fake_args
      subclass = Class.new(subject)
      expect(subclass.associations).to eq(subject.associations)
      subclass.has_many :bars, fake_args
      expect(subclass.associations).to_not eq(subject.associations)
    end

    describe "created instance method" do
      it "is defined" do
        subject.has_many :bars, fake_args
        expect(subject.new(:doc)).to respond_to(:bars)
      end

      it "returns an instance of array" do
        subject.has_many :bars, fake_args
        expect(subject.new(doc).bars).to be_a(Array)
      end

      context "with real data" do
        before(:each) do
          subject.has_many :phones, xpath: "//Phones/Phone", klass: subject
        end
        let(:obj) { subject.new(doc) }

        it "returned array contains klass instances initialized with nodes found from xpath" do
          expect(obj.phones.collect(&:class).uniq.first).to eq(subject)
          expect(obj.phones.size).to eq(2)
        end

        it "caches the value" do
          expect(obj).to receive(:load_association).with(:phones).once.and_return([:foo])
          2.times { obj.phones }
        end
      end
    end
  end

end

