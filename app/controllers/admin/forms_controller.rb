module Admin
  class FormsController < ApplicationController

    def show
      @form_type = params[:form_type]
    end

  end
end
