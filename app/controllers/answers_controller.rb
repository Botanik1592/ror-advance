class AnswersController < ApplicationController
  include Rates

  before_action :authenticate_user!, only: [:create, :destroy, :update]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy, :update, :mark_best]

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
end
