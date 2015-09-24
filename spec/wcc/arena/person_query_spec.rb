require 'spec_helper'

describe WCC::Arena::PersonQuery do
  include FixturesHelpers
  subject { unit.new(args) }
  let(:unit) { WCC::Arena::PersonQuery }
  let(:args) {
    {
      session: double("session")
    }
  }

  describe "#initialize" do
    subject { unit }
    it "sets the session ivar" do
      query = subject.new(args)
      expect(query.session).to eq(args[:session])
    end

    it "defaults session to global config value" do
      query = subject.new
      expect(query.session).to eq(WCC::Arena.config.session)
    end

    it "sets conditions to empty hash" do
      query = subject.new(args)
      expect(query.conditions).to eq({})
    end

    it "sets fields to empty array" do
      query = subject.new(args)
      expect(query.fields).to eq([])
    end
  end

  describe "#where" do
    it "merges hash onto @conditions" do
      subject.where(foo: "bar")
      subject.where(bar: "baz")
      expect(subject.conditions).to eq(foo: "bar", bar: "baz")
    end

    it "returns self" do
      expect(subject.where({})).to eq(subject)
    end
  end

  describe "#order" do
    it "argument 'field1' sets order_field to field1 and order_dir to ASC" do
      subject.order("field1")
      expect(subject.order_field).to eq("field1")
      expect(subject.order_dir).to eq("ASC")
    end

    it "argument 'field1 ASC' sets order_field to field1 and order_dir to ASC" do
      subject.order("field1 ASC")
      expect(subject.order_field).to eq("field1")
      expect(subject.order_dir).to eq("ASC")
    end

    it "argument 'field1 DESC' sets order_field to field1 and order_dir to DESC" do
      subject.order("field1 DESC")
      expect(subject.order_field).to eq("field1")
      expect(subject.order_dir).to eq("DESC")
    end

    it "returns self" do
      expect(subject.order("field")).to eq(subject)
    end
  end

  describe "#select" do
    it "adds attributes to @fields attr" do
      subject.select("foo", "bar")
      subject.select("baz")
      expect(subject.fields).to eq(["foo", "bar", "baz"])
    end

    it "returns self" do
      expect(subject.select("foo")).to eq(subject)
    end
  end

  describe "#call" do
    let(:fixture_response) { xml_fixture_response("person_list.xml") }

    it "makes a get request to /person/list with query params" do
      conditions = { first_name: "Foo", last_name: "Bar" }
      fields = [:first_name, :last_name]
      query = {
        "firstname" => "Foo",
        "lastname" => "Bar",
        "sortfield" => "firstname",
        "sortdirection" => "DESC",
        "fields" => "firstname,lastname",
      }
      expect(subject.session).to receive(:get).with("person/list", query).and_return(fixture_response)
      subject.where(conditions).order("first_name DESC").select(*fields).()
    end

    it "returns a list of Person objects built from the returned records" do
      subject.session.stub(:get) { fixture_response }
      records = subject.()
      expect(records.size).to eq(2)
      expect(records.first).to be_a(WCC::Arena::Person)
      expect(records.first.first_name).to eq("Donald")
      expect(records.first.last_name).to eq("Duck")
    end
  end

end
