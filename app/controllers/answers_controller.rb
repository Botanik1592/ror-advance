class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_question, only: [:create]
  before_action :set_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    question = @answer.question
    if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = 'Answer successfully deleted.'
    else
      flash[:notice] = "You can not remove a foreign matter!"
    end
    redirect_to question
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
