class CreateApplicantService
  class << self
    def create(attrs)
      parse_attributes(attrs)

      begin
        applicant_role_id = ::UserRole.find_by_name('applicant').id
        applicant = Applicant.new(attrs)
        applicant.save!

        new_user = NewUser.create!(new_user_attributes.merge!({original_user_id: applicant.id,
                                                               user_role_id: applicant_role_id,
                                                               created_at: Time.now,
                                                               updated_at: Time.now}))

        create_applicant_answer_form(applicant, new_user.id)
      rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => invalid
        raise Footprints::RecordNotValid.new(applicant)
      end
    end

    private

    attr_accessor :answer_attributes, :new_user_attributes

    def parse_attributes(attrs)
      @new_user_attributes = {}

      attrs.each do |(key, attribute)|
        @new_user_attributes[key] = attribute if new_user_attributes_for_applicant.include?(key)
      end
    end

    def new_user_attributes_for_applicant
      ['name', 'email']
    end

    def create_applicant_answer_form(applicant, new_user_id)
      filled_form_id = ::FilledForm.create(applicant_id: new_user_id,
                                           filler_id: new_user_id,
                                           form_type: 'application',
                                           created_at: Time.now,
                                           updated_at: Time.now).id
      answers = [
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:url],
          filled_form_id: filled_form_id,
          field_choice_id: nil,
          answer_text: applicant.url
        },
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:location],
          filled_form_id: filled_form_id,
          field_choice_id: FieldChoice.find_by_sql("SELECT id FROM field_choices WHERE field_id = #{applicant_answer_mapping[:location]} AND name ILIKE '#{applicant.location}'").first[:id],
          answer_text: nil
        },
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:discipline],
          filled_form_id: filled_form_id,
          field_choice_id: FieldChoice.find_by_sql("SELECT id FROM field_choices WHERE field_id = #{applicant_answer_mapping[:discipline]} AND name ILIKE '#{applicant.discipline}'").first[:id],
          answer_text: nil
        },
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:skill],
          filled_form_id: filled_form_id,
          field_choice_id: FieldChoice.find_by_sql("SELECT id FROM field_choices WHERE field_id = #{applicant_answer_mapping[:skill]} AND name ILIKE '#{applicant.skill}'").first[:id],
          answer_text: nil
        },
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:about],
          filled_form_id: filled_form_id,
          field_choice_id: nil,
          answer_text: applicant.about
        },
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:software_interest],
          filled_form_id: filled_form_id,
          field_choice_id: nil,
          answer_text: applicant.software_interest
        },
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:reason],
          filled_form_id: filled_form_id,
          field_choice_id: nil,
          answer_text: applicant.reason
        },
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:codeschool],
          filled_form_id: filled_form_id,
          field_choice_id: FieldChoice.find_by_sql("SELECT id FROM field_choices WHERE field_id = #{applicant_answer_mapping[:codeschool]} AND name ILIKE '#{applicant.codeschool || 'None'}'").first[:id],
          answer_text: nil
        },
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:college_degree],
          filled_form_id: filled_form_id,
          field_choice_id: FieldChoice.find_by_sql("SELECT id FROM field_choices WHERE field_id = #{applicant_answer_mapping[:college_degree]} AND name ILIKE '#{applicant.college_degree || 'None'}'").first[:id],
          answer_text: nil
        },
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:cs_degree],
          filled_form_id: filled_form_id,
          field_choice_id: FieldChoice.find_by_sql("SELECT id FROM field_choices WHERE field_id = #{applicant_answer_mapping[:cs_degree]} AND name ILIKE '#{applicant.cs_degree || 'None'}'").first[:id],
          answer_text: nil
        },
        {
          user_id: new_user_id,
          field_id: applicant_answer_mapping[:worked_as_dev],
          filled_form_id: filled_form_id,
          field_choice_id: FieldChoice.find_by_sql("SELECT id FROM field_choices WHERE field_id = #{applicant_answer_mapping[:worked_as_dev]} AND name ILIKE '#{applicant.worked_as_dev || 'None'}'").first[:id],
          answer_text: nil
        }
      ].select { |answer| answer[:field_choice_id].present? || answer[:answer_text].present? }

      ::Answer.create!(answers)
    end

    def applicant_answer_mapping
      @applicant_answer_mapping = {
        url: ::Field.find_by_name('Website').id,
        location: ::Field.find_by_name('Preferred Location').id,
        discipline: ::Field.find_by_name('Position').id,
        skill: ::Field.find_by_name('Skill Level').id,
        about: ::Field.find_by_name('Tell us about yourself').id,
        software_interest: ::Field.find_by_name('Why do you love building software').id,
        reason: ::Field.find_by_name('Why do you want to work here?').id,
        codeschool: ::Field.find_by_name('Code School').id,
        college_degree: ::Field.find_by_name('College Degree').id,
        cs_degree: ::Field.find_by_name('CS Degree').id,
        worked_as_dev: ::Field.find_by_name('Worked as Dev').id
      }
    end
  end
end
