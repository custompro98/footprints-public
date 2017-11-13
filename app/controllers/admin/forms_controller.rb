module Admin
  class FormsController < ApplicationController

    def show
      @form_type = params[:form_type]
      @fields    = ::FormService.fields_for_form_type(@form_type)
    end

    def create
      ::CreateFormService.create_form(params[:form_type], params[:questions])

      flash[:notice] = 'Form saved!'
      redirect_to admin_show_form_path(form_type: params[:form_type])
    end
  end
end
