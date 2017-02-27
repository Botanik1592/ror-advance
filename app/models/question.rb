class Question < ApplicationRecord
  include Ratable

  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_many :subscribers, through: :subscriptions, source: :user
  belongs_to :user

  validates :title, :body, presence: true
  validates :title, :body, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  after_create :subscribe_author

  def subscribe_author
    user.subscriptions.create!(question_id: id)
  end
end
