class CreateFormService

  class << self
    def create_form(form_type, form_data)
      CreateFormService.new.create_form(form_type, form_data)
    end
  end

  def create_form(form_type, form_data)
    empty_form_data(form_type)

    form_data.each do |_, field_data|
      next if field_data[:name].blank?

      choices = choices_from(field_data[:answers])

      field = Field.create!(name: field_data[:name],
                            form_type: form_type,
                            has_choices: choices.present?)

      create_choices_for_field(choices, field.id)
    end
  end

  private

  def choices_from(choices)
    return [] unless choices.present?

    choices
      .select { |_, choice| choice[:name].present? }
      .map { |_, choice| choice[:name] }
  end

  def create_choices_for_field(choices, field_id)
    choices.each { |choice| FieldChoice.create!(name: choice, field_id: field_id) }
  end

  def empty_form_data(form_type)
    fields = ::Field.where(form_type: form_type)
    fields.delete_all
    ::FieldChoice.where(id: fields.map(&:id)).delete_all
  end

end
