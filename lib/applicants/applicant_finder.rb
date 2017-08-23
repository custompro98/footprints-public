require './lib/repository'

module Footprints
  class ApplicantFinder

    PAGE_SIZE = 12.freeze

    def repo
      Footprints::Repository.applicant
    end

    def get_applicants(params)
      page = params.fetch(:page, 1)

      if params['status'] == 'archived'
        repo.get_all_archived_applicants(page, PAGE_SIZE)
      elsif ApplicantStateMachine::STATES.include?(params['status'])
        repo.get_applicants_by_state(params['status'])
      elsif params['term'].present?
        repo.find_like(params['term'])
      else
        repo.get_all_unarchived_applicants(page, PAGE_SIZE)
      end
    end

  end
end
