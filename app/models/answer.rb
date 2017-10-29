class Answer < ActiveRecord::Base
  belongs_to :answerer, class_name: 'NewUser', foreign_key: 'user_id'
  belongs_to :field
  belongs_to :filled_form
  belongs_to :field_choice
end
