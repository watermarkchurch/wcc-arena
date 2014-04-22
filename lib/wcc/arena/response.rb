module WCC::Arena

  class Response
    attr_reader :status, :headers, :body

    def initialize(args={})
      @status = args[:status]
      @headers = args[:headers]
      @body = args[:body]
    end

    def xml
      if headers['content-type'] =~ %r[application/xml]
        Nokogiri::XML.parse(@body)
      else
        Nokogiri::XML::Document.new
      end
    end

  end

end
