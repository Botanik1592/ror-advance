class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }
end
