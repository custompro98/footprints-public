require './lib/repository'
class AssignedCraftsmanRecord < ActiveRecord::Base
  belongs_to :craftsman
  belongs_to :applicant

  scope :unarchived_applicants, joins(:applicant).merge(Applicant.not_archived).where(current: true)
end
