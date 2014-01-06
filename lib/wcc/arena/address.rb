module WCC::Arena

  class Address
    include WCC::Arena::Mappers::XML

    attribute :id, xpath: "AddressID"
    attribute :type_id, xpath: "AddressTypeID"
    attribute :type_value, xpath: "AddressTypeValue"
    attribute :city, xpath: "City"
    attribute :country, xpath: "Country"
    attribute :latitude, xpath: "Latitude"
    attribute :longitude, xpath: "Longitude"
    attribute :postal_code, xpath: "PostalCode"
    attribute :primary, xpath: "Primary"
    attribute :state, xpath: "State"
    attribute :street1, xpath: "StreetLine1"
    attribute :street2, xpath: "StreetLine2"

  end

end
