module Admin
  class FieldsController < ApplicationController
    layout false

    def add
      render json: { html: render_to_string('admin/forms/_field_answer_card', locals: { field: OpenStruct.new(name: '', has_choices: false), index: params[:field_number]})}, status: 200
    end

    def add_choice
      render json: { html: render_to_string('admin/forms/_answer_card', locals: { choice: OpenStruct.new(name: ''), index: params[:field_number], choice_index: params[:field_choice_number]})}, status: 200
    end

  end
end
