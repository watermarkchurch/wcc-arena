module WCC::Arena
  class SingleProfileQuery
    attr_reader :session
    attr_reader :profile_id

    def initialize(args={})
      @session = args.fetch(:session) { WCC::Arena.config.session }
      @profile_id = args.fetch(:profile_id)
    end

    def call
      Profile.new(response_profile_xml) if response_profile_xml
    end

    private

    def response_profile_xml
      query_response.xml.root.xpath("/Profile")[0]
    end

    def query_response
      @response ||= session.get("profile/#{profile_id}")
    end
  end
end
