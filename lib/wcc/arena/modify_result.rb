module WCC::Arena

  class ModifyResult
    include Mappers::XML

    attribute :successful, xpath: "Successful", type: :boolean
    attribute :error_message, xpath: "ErrorMessage"
  end

end
