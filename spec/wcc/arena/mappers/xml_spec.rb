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

    context "when :type argument is set" do
      let(:xml_doc) {
        data = [
          "<int>123</int>",
          "<string>a string</string>",
          "<time>2007-01-22T09:57:52.077</time>",
          "<date>1900-01-01T00:00:00</date>",
          "<bool_true1>true</bool>",
          "<bool_true2>True</bool>",
          "<bool_false>false</bool_false>",
        ].join
        Nokogiri::XML.parse("<doc>#{data}</doc>")
      }
      let(:obj) { subject.new(xml_doc) }

      it "converts to an integer when type is :integer" do
        subject.attribute :int, xpath: "//int", type: :integer
        expect(obj.int).to eq(123)
      end

      it "does no conversion type is :string" do
        subject.attribute :string, xpath: "//string", type: :string
        expect(obj.string).to eq("a string")
      end

      it "converts to a date when type is :date" do
        subject.attribute :date, xpath: "//date", type: :date
        expect(obj.date).to eq(Date.new(1900, 1, 1))
      end

      it "converts to a time when type is :time" do
        subject.attribute :time, xpath: "//time", type: :time
        expect(obj.time).to be_within(1).of(Time.new(2007, 1, 22, 9, 57, 52))
      end

      it "converts to a boolean when type is :boolean" do
        subject.attribute :bool_true1, xpath: "//bool_true1", type: :boolean
        subject.attribute :bool_true2, xpath: "//bool_true2", type: :boolean
        subject.attribute :bool_false, xpath: "//bool_false", type: :boolean
        subject.attribute :bool_undef, xpath: "//notindocument", type: :boolean
        expect(obj.bool_true1).to eq(true)
        expect(obj.bool_true2).to eq(true)
        expect(obj.bool_false).to eq(false)
        expect(obj.bool_undef).to be_nil
      end
    end

  end

  describe "::add_association" do
    let(:fake_args) { { xpath: "foo", klass: "foo", type: :many } }

    it "requires xpath option" do
      fake_args.delete(:xpath)
      expect { subject.add_association :foos, fake_args }.to raise_error(ArgumentError)
    end

    it "requires klass option" do
      fake_args.delete(:klass)
      expect { subject.add_association :foos, fake_args }.to raise_error(ArgumentError)
    end

    it "requires type option" do
      fake_args.delete(:type)
      expect { subject.add_association :foos, fake_args }.to raise_error(ArgumentError)
    end

    it "stores data in @associations class ivar hash" do
      subject.add_association :foos, fake_args
      expect(subject.associations[:foos]).to eq(fake_args)
    end

    it "freezes the options" do
      subject.add_association :foos, fake_args
      expect { subject.associations[:foos][:bar] = "test" }.to raise_error(RuntimeError)
    end

    it "flows down the class hierarchy" do
      subject.add_association :foos, fake_args
      subclass = Class.new(subject)
      expect(subclass.associations).to eq(subject.associations)
      subclass.add_association :bars, fake_args
      expect(subclass.associations).to_not eq(subject.associations)
    end

    it "defines an instance method with the included block if provided" do
      ping = :not_called
      subject.add_association :foos, fake_args do
        ping = :called
      end
      obj = subject.new(:doc)
      expect(obj).to respond_to(:foos)
      obj.foos
      expect(ping).to eq(:called)
    end
  end

  describe "::has_one" do
    let(:fake_args) { { xpath: "foo", klass: "foo" } }

    it "calls add_association with args and type merged in" do
      expect(subject).to receive(:add_association).with(:foo, fake_args.merge(type: :one))
      subject.has_one :foo, fake_args
    end

    describe "created instance method" do
      it "is defined" do
        subject.has_one :foo, fake_args
        expect(subject.new(:doc)).to respond_to(:foo)
      end

      it "returns nil when document has no match" do
        subject.has_one :foo, fake_args.merge(klass: Class.new)
        expect(subject.new(doc).foo).to be_nil
      end

      context "with real data" do
        before(:each) do
          subject.has_one :person, klass: WCC::Arena::Person, xpath: "/Person"
        end
        let(:obj) { subject.new(doc) }

        it "returns an instance of class when the document does have a match" do
          expect(obj.person).to be_a(WCC::Arena::Person)
        end

        it "caches the value" do
          expect(obj).to receive(:load_association).with(:person).once.and_return(:foo)
          2.times { obj.person }
        end
      end
    end
  end

  describe "::has_many" do
    let(:fake_args) { { xpath: "foo", klass: "foo" } }

    it "calls add_association with args and type merged in" do
      expect(subject).to receive(:add_association).with(:foo, fake_args.merge(type: :many))
      subject.has_many :foo, fake_args
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

