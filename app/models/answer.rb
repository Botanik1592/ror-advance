class Answer < ApplicationRecord
  validates :body, presence: true
  validates :body, length: { minimum: 10 }
end
