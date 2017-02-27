class Answer < ApplicationRecord
  include Ratable

  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true, length: { minimum: 10 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order('best DESC') }

  after_create :send_notification

  def mark_best
    transaction do
      Answer.where(question_id: self.question.id, best: true).update_all(best: false)
      self.update!(best: true)
    end
  end

  def send_notification
    SendAnswerNotificationJob.perform_later self
  end
end
