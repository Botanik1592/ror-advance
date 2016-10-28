class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true, length: { minimum: 10 }

  default_scope { order('best DESC') }

  def mark_best
    transaction do
      Answer.where(question_id: self.question.id, best: true).update_all(best: false)
      self.update!(best: true)
    end
  end
end
