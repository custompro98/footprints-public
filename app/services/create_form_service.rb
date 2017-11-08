class CreateFormService
  class << self

    def create_form(form_type, form_data)
      empty_form_data

      form_data.each do |_, field_data|
        next if field_data[:name].blank?

        answers = (field_data[:answers] || []).map do |_, answer|
          answer[:name] if answer[:name].present?
        end.compact

        field = Field.create!(name: field_data[:name],
                              form_type: form_type,
                              has_choices: answers.present?)

        if field.has_choices
          answers.each do |answer|
            FieldChoice.create!(name: answer, field_id: field.id)
          end
        end
      end
    end

    private

    def empty_form_data
      ::Field.delete_all
      ::FieldChoice.delete_all
    end

  end
end
