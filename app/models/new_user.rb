class NewUser < ActiveRecord::Base
  belongs_to :user_role
  has_one :salary, class_name: 'UserSalary', foreign_key: :user_id
  has_many :answers, foreign_key: :user_id
  has_many :form_assignees, foreign_key: :user_id
  has_many :assigned_forms, through: :form_assignees, source: :filled_form

  def original_user
    UserRole.find(user_role_id).name == 'applicant' ? Applicant.find(original_user_id) : Craftsman.find(original_user_id)
  end

  def status
    Craftsman.find(original_user_id).status
  end

  def employment_id
    Craftsman.find(original_user_id).employment_id
  end

  def self.find_by_employment_id(employment_id)
    find_by_original_user_id(Craftsman.find_by_employment_id(employment_id).id)
  end

  def self.find_by_id(id)
    find_by_original_user_id(Craftsman.find_by_id(id).id)
  end

  def self.find_by_name(name)
    find_by_original_user_id(Craftsman.find_by_name(name).try(:id))
  end
end
