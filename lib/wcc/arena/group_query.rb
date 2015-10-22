module WCC::Arena
  class GroupQuery
    attr_reader :session
    attr_reader :person_id
    attr_reader :category_id

    def initialize(args={})
      @session = args.fetch(:session) { WCC::Arena.config.session }
      @person_id = args.fetch(:person_id)
      @category_id = args.fetch(:category_id)
    end

    def call
      response_groups_xml.collect do |person_xml|
        Group.new(person_xml)
      end
    end

    private

    def response_groups_xml
      query_response.xml.root.xpath("Groups/Group[not(LeaderID='-1')]")
    end

    def query_response
      @response ||= session.get(
        "person/#{person_id}/group/list",
        categoryid: category_id
      )
    end
  end
end
