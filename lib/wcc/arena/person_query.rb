module WCC::Arena

  class PersonQuery
    attr_reader :session
    attr_reader :conditions, :fields
    attr_reader :order_field, :order_dir

    def initialize(args={})
      @session = args.fetch(:session) { WCC::Arena.config.session }
      @conditions = {}
      @fields = []
    end

    def where(condition)
      conditions.merge!(condition)
      self
    end

    def order(ordering)
      @order_field, @order_dir = ordering.split
      self
    end

    def select(*fields)
      @fields += fields
      self
    end

    def order_dir
      @order_dir || "ASC"
    end

    def call
      response_people_xml.collect do |person_xml|
        Person.new(person_xml)
      end
    end

    private

    def response_people_xml
      query_response.xml.root.xpath("Persons/Person")
    end

    def query_response
      @response ||= session.get(
        "person/list",
        prepared_conditions.merge(sort_arguments).merge(field_arguments)
      )
    end

    def prepared_conditions
      conditions.each_with_object({}) do |(field, value), conditions|
        conditions[prepared_field_name(field)] = value
      end
    end

    def field_arguments
      if fields.empty?
        {}
      else
        {
          "fields" => fields.map { |field| prepared_field_name(field) }.join(",")
        }
      end
    end

    def sort_arguments
      if order_field
        {
          "sortfield" => prepared_field_name(order_field),
          "sortdirection" => order_dir,
        }
      else
        {}
      end
    end

    def prepared_field_name(name)
      name.to_s.gsub("_", "")
    end

  end

end
