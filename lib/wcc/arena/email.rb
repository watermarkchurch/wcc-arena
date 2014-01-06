module WCC::Arena

  class Email
    include WCC::Arena::Mappers::XML

    attribute :address, xpath: "Address"

  end

end
