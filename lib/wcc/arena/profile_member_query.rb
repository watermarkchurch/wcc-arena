module WCC::Arena

  class ProfileMemberQuery
    attr_reader :session, :profile_id

    def initialize(args={})
      @session = args.fetch(:session) { WCC::Arena.config.session }
      @profile_id = args.fetch(:profile_id)
    end

    def call
      members_xml.collect do |member_xml|
        ProfileMember.new(member_xml)
      end
    end

    private

    def members_xml
      query_response.xml.root.xpath("ProfileMembers/ProfileMember")
    end

    def query_response
      @response ||= session.get(
        "profile/#{profile_id}/member/list",
        fields: "personid"
      )
    end
  end

end
