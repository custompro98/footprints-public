class CreateCraftsmanService
  class << self
    def create(attrs)
      parse_attributes(attrs)

      begin
        craftsman = Craftsman.new(old_craftsman_attributes)
        craftsman.save!
        NewUser.create!(new_user_attributes.merge!({original_user_id: craftsman.id}))
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => invalid
        raise Footprints::RecordNotValid.new(craftsman)
      end
    end

    private

    attr_accessor :new_user_attributes, :old_craftsman_attributes

    def parse_attributes(attrs)
      @old_craftsman_attributes = {}
      @new_user_attributes = {}

      attrs.each do |(key, attribute)|
        @new_user_attributes[key] = attribute if new_user_attributes_for_craftsmen.include?(key)
        @old_craftsman_attributes[key] = attribute
      end

      @new_user_attributes[:user_role_id] = ::UserRole.find_by_name('crafter').id
    end

    def new_user_attributes_for_craftsmen
      [:name]
    end
  end
end
