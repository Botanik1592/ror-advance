class AnswersListSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :user_id, :best

  has_many :attachments
  has_many :comments
end
