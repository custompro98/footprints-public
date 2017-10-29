class NewUser < ActiveRecord::Base
  belongs_to :user_role
  has_one :salary, class_name: 'UserSalary', foreign_key: :user_id
  has_many :answers, foreign_key: :user_id
  has_many :form_assignees, foreign_key: :user_id
  has_many :assigned_forms, through: :form_assignees, source: :filled_form
end
