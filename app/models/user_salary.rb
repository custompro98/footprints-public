class UserSalary < ActiveRecord::Base
  belongs_to :user, class_name: 'NewUser', foreign_key: :user_id
end
