class Field < ActiveRecord::Base
  has_many :choices, class_name: 'FieldChoice'
end
