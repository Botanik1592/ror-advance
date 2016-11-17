class Rating < ApplicationRecord
  belongs_to :ratable, polymorphic: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: :ratable_id }
  validates :ratings, inclusion: { in: [1, -1] }
end
