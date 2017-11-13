module Admin
  class FormsController < ApplicationController

    def show
      respond_to do |format|
        format.js { flash.now[:notice] = 'Form saved!' }
        format.html do
          @form_type = params[:form_type]
          @fields    = ::FormService.fields_for_form_type(@form_type)
        end
      end
    end

    def create
      ::CreateFormService.create_form(params[:form_type], params[:questions])

      redirect_to admin_show_form_path(form_type: params[:form_type])
    end
  end
end
