module WCC::Arena

  class Session
    attr_reader :connection, :username, :password, :api_key, :api_secret

    DEFAULT_POST_HEADERS = {
      content_type: "text/xml",
    }

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
      if !date_expires_node.text.empty?
        Time.parse(date_expires_node.text)
      else
        Time.new(0)
      end
    end

    def get(path, query={})
      reset unless valid?
      build_response(connection.get(signed_path(path, query)))
    end

    def post(path, query={}, body=nil)
      reset unless valid?
      build_response(connection.post(signed_path(path, query), body, DEFAULT_POST_HEADERS))
    end

    def valid?
      login_response.status == 200 &&
        expires > Time.now &&
        !id.empty?
    end

    def reset
      @login_response = nil
    end

    private

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
      login_root_node.at("SessionID") || NullNode.new
    end

    def date_expires_node
      login_root_node.at("DateExpires") || NullNode.new
    end

    def login_root_node
      login_response.xml.root || NullNode.new
    end

    def login_response
      @login_response ||= build_response(
        connection.post("login", {
          username: username,
          password: password,
          api_key: api_key,
        })
      )
    end

    class NullNode
      def text
        ""
      end

      def at(*args)
        self
      end
    end

  end

end
