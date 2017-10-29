class UserRole < ActiveRecord::Base
  has_many :users, class_name: 'NewUser'
end
