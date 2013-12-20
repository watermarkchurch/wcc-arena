require 'uri'
require 'digest/md5'

module WCC::Arena

  class SignedPath
    attr_reader :path, :query, :session_id, :api_secret

    def initialize(args={})
      @path = args.fetch(:path)
      @session_id = args.fetch(:session_id)
      @api_secret = args.fetch(:api_secret)
      @query = args.fetch(:query) { Hash.new }
    end

    def call
      [
        path_with_session,
        "api_sig=#{api_sig}",
      ].join("&")
    end

    def path_with_session
      [
        path,
        URI.encode_www_form(query.merge(api_session: session_id)),
      ].join("?")
    end

    def api_sig
      Digest::MD5.hexdigest("#{api_secret}_#{path_with_session.downcase}")
    end

  end

end
