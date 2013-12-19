module WCC::Arena
  class Config
    attr_accessor :username, :password, :api_key, :api_secret
    attr_accessor :api_url
    attr_accessor :logger, :connection

    def connection
      @connection ||= default_connection
    end

    private

    def default_connection
      Faraday.new(url: api_url) do |faraday|
        faraday.response :logger
        faraday.adapter Faraday.default_adapter
      end
    end
  end

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end
end
