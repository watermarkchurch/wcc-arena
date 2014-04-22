require 'spec_helper'

describe WCC::Arena::Response do
  let(:args) {
    {
      status: 200,
      headers: { "foo" => "bar" },
      body: "foo",
    }
  }
  let(:xml_args) {
    {
      status: 200,
      headers: { "content-type" => "application/xml; charset=utf-8" },
      body: "<Some><AwesomeBody></AwesomeBody></Some>",
    }
  }
  let(:generic_response) { WCC::Arena::Response.new(args) }
  let(:xml_response) { WCC::Arena::Response.new(xml_args) }

  describe "#initialize" do
    subject { WCC::Arena::Response }
    it "sets a @status, @headers, and @body" do
      obj = subject.new(args)
      expect(obj.status).to eq(args[:status])
      expect(obj.headers).to eq(args[:headers])
      expect(obj.body).to eq(args[:body])
    end
  end

  describe "#xml" do
    it "returns an XML document when response has that content-type" do
      expect(xml_response.xml).to be_a(Nokogiri::XML::Document)
      expect(xml_response.xml.root.name).to eq("Some")
    end

    it "returns an empty XML document when the response is not XML" do
      expect(generic_response.xml).to be_a(Nokogiri::XML::Document)
      expect(generic_response.xml.root).to be_nil
    end
  end

end
