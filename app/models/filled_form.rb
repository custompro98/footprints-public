class FilledForm < ActiveRecord::Base
  belongs_to :applicant, class_name: 'NewUser', foreign_key: :applicant_id
  belongs_to :filler, class_name: 'NewUser', foreign_key: :filler_id
  has_many :answers
end
