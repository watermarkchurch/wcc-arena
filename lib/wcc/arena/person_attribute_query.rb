module WCC::Arena
  class PersonAttributeQuery
    attr_reader :session, :person_id

    def initialize(args={})
      @session = args.fetch(:session) { WCC::Arena.config.session }
      @person_id = args.fetch(:person_id)
    end

    def call
      response_groups_xml.collect do |xml|
        PersonAttributeGroup.new(xml)
      end
    end

    private

    def response_groups_xml
      query_response.xml.root.xpath("AttributeGroups/AttributeGroup")
    end

    def query_response
      @response ||= session.get(
        "person/#{person_id}/attribute/list"
      )
    end

  end
end
