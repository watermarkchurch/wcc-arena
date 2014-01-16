require 'spec_helper'

describe WCC::Arena::ProfileMemberSave do
  include FixturesHelpers

  let(:unit) { WCC::Arena::ProfileMemberSave }
  let(:args) {
    {
      profile_id: 1,
      person_id: 2,
      session: double(:session),
      save_data: double(:data, to_xml: :xml),
    }
  }
  let(:obj) { unit.new(args) }
  subject { obj }

  describe "#initialize" do
    subject { unit }

    it "sets arguments" do
      expect(obj.session).to eq(args[:session])
      expect(obj.person_id).to eq(args[:person_id])
      expect(obj.profile_id).to eq(args[:profile_id])
      expect(obj.save_data).to eq(args[:save_data])
    end

    it "defaults session to global config" do
      args.delete(:session)
      expect(obj.session).to eq(WCC::Arena.config.session)
    end

    it "requires a :profile_id" do
      args.delete(:profile_id)
      expect { obj }.to raise_error(KeyError)
    end

    it "requires a :person_id" do
      args.delete(:person_id)
      expect { obj }.to raise_error(KeyError)
    end

    it "defaults :save_data to basic ProfileMemberSaveData instance" do
      args.delete(:save_data)
      expect(obj.save_data).to be_a(WCC::Arena::ProfileMemberSaveData)
    end

    it "accepts :new_record argument" do
      args[:new_record] = :foo
      expect(obj.new_record).to eq(:foo)
    end

    it "defaults @new_record to true" do
      expect(obj.new_record).to be_true
    end
  end

  describe "#call" do
    let(:success_xml) { xml_fixture_response("modify_result_success.xml") }

    context "with a new_record" do
      it "calls post on the session with profile/<profileid>/member/<personid>/add and XML" do
        expect(obj.session).to receive(:post).with("profile/1/member/2/add", {}, :xml).and_return(success_xml)
        obj.()
      end
    end

    context "with an existing record" do
      before(:each) { args[:new_record] = false }
      it "calls post on the session with profile/<profileid>/member/<personid>/update and XML" do
        expect(obj.session).to receive(:post).with("profile/1/member/2/update", {}, :xml).and_return(success_xml)
        obj.()
      end
    end

    it "returns a ModifyResult instance" do
      expect(obj.session).to receive(:post).and_return(success_xml)
      result = obj.()
      expect(result).to be_a(WCC::Arena::ModifyResult)
      expect(result.successful).to be_true
    end
  end

end

describe WCC::Arena::ProfileMemberSaveData do
  include FixturesHelpers
  ARENA_NEVER = "9999-12-31T23:59:59.997"

  let(:unit) { WCC::Arena::ProfileMemberSaveData }

  describe "#initialize" do
    subject { unit }
    it "takes :attributes argument and stores in @attributes" do
      obj = subject.new(foo: :bar)
      expect(obj.attributes).to eq(foo: :bar)
    end
  end

  describe "#arena_attributes" do
    let(:now) { Time.now }
    let(:never) { Time.parse(ARENA_NEVER) }
    let(:arena_defaults) {
      {
        "DateActive" => now,
        "DateDormant" => never,
        "DateInReview" => never,
        "DatePending" => now,
        "MemberNotes" => nil,
        "PrerequisitesMet" => false,
        "SourceID" => 272,
        "SourceValue" => "Unknown",
        "StatusID" => 255,
        "StatusReason" => nil,
        "StatusValue" => "Connected",
      }
    }

    it "uses the default attributes" do
      attrs = unit.new.arena_attributes(now)
      expect(attrs).to eq(arena_defaults)
    end

    it "defaults argument to Time.now" do
      attrs = unit.new.arena_attributes
      expect(attrs["DateActive"]).to be_within(1).of(Time.now)
    end

    it "allows overriding default attributes" do
      attrs = unit.new(active_at: never, pending_at: never).arena_attributes
      expect(attrs["DateActive"]).to eq(never)
      expect(attrs["DatePending"]).to eq(never)
    end

  end

  describe "#to_xml" do
    let(:fixture_xml) { xml_fixture("profile_member_save.xml") }
    let(:xml_now) { Time.parse("2012-02-09T09:10:29.093") }
    let(:attributes) {
      {
        active_at: xml_now,
        pending_at: xml_now
      }
    }

    it "creates XML from #arena_attributes" do
      expect(unit.new(attributes).to_xml).to eq(fixture_xml)
    end
  end

end
