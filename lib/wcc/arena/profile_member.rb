require 'wcc/arena/profile_member_query'

module WCC::Arena

  class ProfileMember
    include WCC::Arena::Mappers::XML

    attribute :profile_id, xpath: "ProfileID", type: :integer
    attribute :person_id, xpath: "PersonInformation/PersonID", type: :integer

    def person
      @person ||= PersonQuery.new.where(person_id: person_id).()[0]
    end

  end

end
