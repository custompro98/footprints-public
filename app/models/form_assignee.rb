class FormAssignee < ActiveRecord::Base
  belongs_to :assignee, class_name: 'NewUser', foreign_key: :user_id
  belongs_to :filled_form
  has_one :applicant, through: :filled_form, foreign_key: :applicant_id
end
