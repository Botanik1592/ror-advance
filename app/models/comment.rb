class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user_id, :body, presence: true
  validates :body, length: { minimum: 3}
end
