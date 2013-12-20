module WCC::Arena

  class Session
    attr_reader :connection, :username, :password, :api_key, :api_secret

    def initialize(args={})
      @connection = args.fetch(:connection) { WCC::Arena.config.connection }
      @username = args.fetch(:username)
      @password = args.fetch(:password)
      @api_key = args.fetch(:api_key)
      @api_secret = args.fetch(:api_secret)
    end

    def id
      session_id_node.text
    end

    def expires
      if date_expires_node.text
        Time.parse(date_expires_node.text)
      end
    end

    def get(path, query={})
      make_signed_request(:get, path, query)
    end

    def post(path, query={})
      make_signed_request(:post, path, query)
    end

    private

    def make_signed_request(method, path, query)
      build_response(connection.public_send(method, signed_path(path, query)))
    end

    def build_response(faraday_response)
      Response.new(
        status: faraday_response.status,
        headers: faraday_response.headers,
        body: faraday_response.body
      )
    end

    def signed_path(path, query)
      SignedPath.new(
        path: path,
        query: query,
        session_id: id,
        api_secret: api_secret
      ).()
    end

    def session_id_node
      root_node.at("SessionID") || NullNode.new
    end

    def date_expires_node
      root_node.at("DateExpires") || NullNode.new
    end

    def root_node
      response.xml.root
    end

    def response
      @response ||= build_response(
        connection.post("login", {
          username: username,
          password: password,
          api_key: api_key,
        })
      )
    end

    class NullNode
      def text
        nil
      end
    end

  end

end
