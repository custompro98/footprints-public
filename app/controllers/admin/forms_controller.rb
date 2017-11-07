module Admin
  class FormsController < ApplicationController

    def show
      @form_type = params[:form_type]
      @fields    = ::FormService.fields_for_form_type(@form_type)
    end

    def create
      Field.delete_all
      FieldChoice.delete_all

      params[:questions].each do |question_number, question_data|
        next if question_data[:name].blank?
        answers = (question_data[:answers] || []).map { |k, a| a[:name] if a[:name].present? }
        field = Field.create!(name: question_data[:name], form_type: params[:form_type], has_choices: answers.present?)
        if field.has_choices
          answers.each do |answer|
            FieldChoice.create!(name: answer, field_id: field.id)
          end
        end
      end

      flash[:notice] = 'Form saved!'
      redirect_to admin_show_form_path(form_type: params[:form_type])
    end
  end
end
