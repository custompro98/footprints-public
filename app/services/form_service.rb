class FormService
  class << self

    def fields_for_form_type(form_type)
      ::Field.where(form_type: form_type)
    end

  end
end
