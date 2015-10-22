require 'wcc/arena/profile_member_query'

module WCC::Arena

  class ProfileMember
    include WCC::Arena::Mappers::XML

    attribute :profile_id, xpath: "ProfileID", type: :integer
    attribute :person_id, xpath: "PersonInformation/PersonID", type: :integer

    def person
      @person ||= SinglePersonQuery.new(person_id: person_id).()
    end

  end

end
