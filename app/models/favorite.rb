class Favorite < ActiveRecord::Base
  belongs_to :favorer, class_name: :User
  belongs_to :question

  scope :by, lambda { |user| where(favorer: user) }
end
