module WCC::Arena

  class ProfileQuery
    attr_reader :session
    attr_reader :profile_type_id, :parent_profile_id

    def initialize(args={})
      @session = args.fetch(:session) { WCC::Arena.config.session }
      @profile_type_id = args[:profile_type_id]
      @parent_profile_id = args[:parent_profile_id]
      if profile_type_id && parent_profile_id || !profile_type_id && !parent_profile_id
        raise ArgumentError,
          "Either `profile_type_id' or `parent_profile_id' must be provided but not both"
      end
    end

    def call
      response_profiles_xml.collect do |profile_xml|
        Profile.new(profile_xml)
      end
    end

    private

    def response_profiles_xml
      query_response.xml.root.xpath("Profiles/Profile[not(@i:nil=\"true\")]")
    end

    def query_response
      @response ||= session.get(
        request_path,
        request_args
      )
    end

    def request_path
      if parent_profile_id
        "profile/#{parent_profile_id}/list"
      else
        "profile/list"
      end
    end

    def request_args
      if profile_type_id
        {
          profiletype: profile_type_id,
        }
      else
        {}
      end
    end

  end

end
