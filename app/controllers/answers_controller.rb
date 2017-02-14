class AnswersController < ApplicationController
  include Rates

  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy, :update, :mark_best]
  after_action :publish_answer, only: [:create]

  def create
    @answer = @question.answers.new(answer_params)
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
  end

  def destroy
    @answer.destroy if current_user.author_of?(@answer)
  end

  def mark_best
    if current_user.author_of?(@answer.question)
      @answer.mark_best
    end
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end

  def publish_answer
    return if @answer.errors.any?

    attachments = []
    @answer.attachments.each { |a| attachments << {id: a.id, file_url: a.file.url, file_name: a.file.identifier} }

    data = {
      answer: @answer,
      answer_user_id: current_user.id,
      question_user_id: @question.user_id,
      answer_rating: @answer.show_rate,
      answer_attachments: attachments
    }
    ActionCable.server.broadcast("answers_#{params[:question_id]}", data)
  end
end
