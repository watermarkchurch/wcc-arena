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
      groups = response_groups_xml.map { |person_xml| Group.new(person_xml) }
      groups.uniq { |g| g.id }
    end

    private

    def response_groups_xml
      query_response.xml.root.xpath("Groups/Group[Active='true']")
    end

    def query_response
      @response ||= session.get(
        "person/#{person_id}/group/list",
        categoryid: category_id
      )
    end
  end
end
