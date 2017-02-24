class OneQuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :created_at, :updated_at, :user_id, :ratings
  has_many :answers
  has_many :attachments
  has_many :comments
end
