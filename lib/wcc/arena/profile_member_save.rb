module WCC::Arena

  class ProfileMemberSave
    attr_reader :session
    attr_reader :profile_id, :person_id
    attr_reader :save_data, :new_record

    def initialize(args={})
      @session = args.fetch(:session) { WCC::Arena.config.session }
      @profile_id = args.fetch(:profile_id)
      @person_id = args.fetch(:person_id)
      @save_data = args.fetch(:save_data) { ProfileMemberSaveData.new }
      @new_record = args.fetch(:new_record) { true }
    end

    def call
      ModifyResult.new(result_xml)
    end

    private

    def result_xml
      query_response.xml.root
    end

    def query_response
      @response ||= session.post(
        "profile/#{profile_id}/member/#{person_id}/#{service_verb}",
        {},
        save_data.to_xml
      )
    end

    def service_verb
      new_record ? "add" : "update"
    end

  end

  class ProfileMemberSaveData
    attr_reader :attributes

    TIME_FORMAT = "%Y-%m-%dT%H:%M:%S.%L"
    NEVER = Time.local(9999, 12, 31, 23, 59, 59, 997000)

    ATTRIBUTE_MAP = {
      "active_at" => "DateActive",
      "pending_at" => "DatePending",
    }

    def initialize(attributes={})
      @attributes = attributes
    end

    def arena_attributes(now = Time.now)
      {
        "DateActive" => now,
        "DateDormant" => NEVER,
        "DateInReview" => NEVER,
        "DatePending" => now,
        "MemberNotes" => nil,
        "PrerequisitesMet" => false,
        "SourceID" => 272,
        "SourceValue" => "Unknown",
        "StatusID" => 255,
        "StatusReason" => nil,
        "StatusValue" => "Connected",
      }.merge(mapped_attributes)
    end

    def to_xml
      doc = Nokogiri::XML::Builder.new
      doc.ProfileMember do |root|
        arena_attributes.each do |key, value|
          case value
          when nil
            root.send key
          when Time
            root.send key, value.strftime(TIME_FORMAT)
          else
            root.send key, value
          end
        end
      end
      doc.to_xml
    end

    private

    def mapped_attributes
      attributes.each_with_object({}) { |(key, value), hash|
        if mapped_key = ATTRIBUTE_MAP[key.to_s]
          hash[mapped_key] = value
        end
      }
    end

  end

end
