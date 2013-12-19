module WCC::Arena

  class Session
    attr_reader :connection, :username, :password, :api_key

    def initialize(args={})
      @connection = args.fetch(:connection) { WCC::Arena.config.connection }
      @username = args.fetch(:username)
      @password = args.fetch(:password)
      @api_key = args.fetch(:api_key)
    end

    def id
      session_id_node.text
    end

    def expires
      if date_expires_node.text
        Time.parse(date_expires_node.text)
      end
    end

    private

    def session_id_node
      root_node.at("SessionID") || NullNode.new
    end

    def date_expires_node
      root_node.at("DateExpires") || NullNode.new
    end

    def root_node
      parsed_response.root
    end

    def parsed_response
      @parsed ||= Nokogiri::XML.parse(raw_response.body)
    end

    def raw_response
      @raw ||= connection.post "login", {
        username: username,
        password: password,
        api_key: api_key,
      }
    end

    class NullNode
      def text
        nil
      end
    end

  end

end
