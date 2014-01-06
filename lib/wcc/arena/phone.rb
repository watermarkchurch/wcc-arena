module WCC::Arena

  class Phone
    include WCC::Arena::Mappers::XML

    attribute :extension, xpath: "Extension"
    attribute :number, xpath: "Number"
    attribute :type_id, xpath: "PhoneTypeID"
    attribute :type_value, xpath: "PhoneTypeValue"

    alias :type :type_value

  end

end
