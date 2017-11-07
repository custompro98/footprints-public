module Admin
  class FormsController < ApplicationController

    def show
      @form_type = params[:form_type]
      @fields    = ::FormService.fields_for_form_type(@form_type)
    end

  end
end
