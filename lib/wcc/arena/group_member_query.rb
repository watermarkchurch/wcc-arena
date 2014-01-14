module WCC::Arena

  class GroupMemberQuery
    attr_reader :session
    attr_reader :group_id

    def initialize(args={})
      @session = args.fetch(:session) { WCC::Arena.config.session }
      @group_id = args.fetch(:group_id)
    end

    def call
      members_xml.collect do |member_xml|
        GroupMember.new(member_xml)
      end
    end

    private

    def members_xml
      query_response.xml.root.xpath("Members/GroupMember")
    end

    def query_response
      @response ||= session.get(
        "group/#{group_id}/member/list"
      )
    end

  end

end
