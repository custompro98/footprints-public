require 'ar_repository/models/applicant'

module External
  class ApplicantsController < ApplicationController
    layout 'external'

    def show
      @applicant = ::Applicant.find(params[:id])
    end

    def new
      @applicant = repo.applicant.new
    end

    def create
      @applicant = repo.applicant.new(applicant_params)
      @applicant.save!
      # TODO: assign craftsmen here
      redirect_to(external_applicant_path(@applicant), :notice => "Your application was submitted successfully!")
    rescue StandardError => e
      flash.now[:error] = [e.message]
      render :new
    end

    private

    def applicant_params
      user_params.merge!({applied_on: DateTime.now.utc})
    end

    def user_params
      params.require(:applicant).permit(:name, :email, :codeschool, :college_degree, :cs_degree, :worked_as_dev, :url, :skill, :discipline, :about, :software_interest, :reason, :location)
    end

  end
end
