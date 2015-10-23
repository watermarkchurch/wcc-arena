module WCC::Arena
  class SinglePersonQuery
    attr_reader :session
    attr_reader :person_id

    def initialize(args={})
      @session = args.fetch(:session) { WCC::Arena.config.session }
      @person_id = args.fetch(:person_id)
    end

    def call
      Person.new(response_person_xml) if response_person_xml
    end

    private

    def response_person_xml
      query_response.xml.root.xpath("/Person")[0]
    end

    def query_response
      @response ||= session.get("person/#{person_id}")
    end
  end
end
