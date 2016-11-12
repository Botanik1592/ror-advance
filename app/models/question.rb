class Question < ApplicationRecord
  include Ratable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank
end
