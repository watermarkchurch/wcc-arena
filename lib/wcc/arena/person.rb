require 'wcc/arena/person_query'
require 'wcc/arena/single_person_query'

require 'wcc/arena/address'
require 'wcc/arena/email'
require 'wcc/arena/person_attribute_group'
require 'wcc/arena/person_attribute_query'
require 'wcc/arena/phone'

module WCC::Arena

  class Person
    include WCC::Arena::Mappers::XML

    DEFAULT_CATEGORY_ID = 1
    IS_MEMBER_STATUS_ID = 7404

    attribute :id, xpath: "PersonID", type: :integer
    attribute :guid, xpath: "PersonGUID"

    attribute :first_name, xpath: "FirstName"
    attribute :nick_name, xpath: "NickName"
    attribute :middle_name, xpath: "MiddleName"
    attribute :last_name, xpath: "LastName"
    attribute :full_name, xpath: "FullName"

    attribute :age, xpath: "Age", type: :integer
    attribute :birth_date, xpath: "BirthDate", type: :date
    attribute :campus_name, xpath: "CampusName"
    attribute :family_id, xpath: "FamilyID", type: :integer
    attribute :gender, xpath: "Gender"
    attribute :member_status_id, xpath: "MemberStatusID", type: :integer
    attribute :member_status_value, xpath: "MemberStatusValue"
    attribute :status, xpath: "RecordStatusValue"
    attribute :profile_picture_link, xpath: "BlobLink"

    attribute :home_phone, xpath: "HomePhone"
    attribute :business_phone, xpath: "BusinessPhone"
    attribute :cell_phone, xpath: "CellPhone"

    attribute :email, xpath: "FirstActiveEmail"

    alias :member_status :member_status_value

    has_many :addresses, xpath: "Addresses/Address", klass: Address
    has_many :emails, xpath: "Emails/Email", klass: Email
    has_many :phones, xpath: "Phones/Phone", klass: Phone

    def member?
      member_status_id == IS_MEMBER_STATUS_ID
    end

    def groups
      @groups ||= GroupQuery.new(person_id: id, category_id: DEFAULT_CATEGORY_ID).()
    end

    def attribute_groups
      @attribute_groups ||= PersonAttributeQuery.new(person_id: id).()
    end

    def add_profile(profile_id)
      ProfileMemberSave.new(person_id: id, profile_id: profile_id).()
    end
    alias :add_tag :add_profile

  end

end
