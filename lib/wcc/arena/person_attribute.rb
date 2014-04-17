module WCC::Arena
  class PersonAttribute
    include WCC::Arena::Mappers::XML

    attribute :id, xpath: "AttributeID", type: :integer
    attribute :name, xpath: "AttributeName"
    attribute :display_value, xpath: "DisplayValue"
    attribute :int_value, xpath: "IntValue", type: :integer
    attribute :date_value, xpath: "DateValue", type: :date

  end
end
