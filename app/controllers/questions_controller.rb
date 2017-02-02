class QuestionsController < ApplicationController
  include Rates

  before_action :authenticate_user!, except: [ :index, :show ]
  before_action :set_question, except: [ :index, :new, :create ]
  after_action :publish_question, only: [:create]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build
    @answer.attachments.build
  end

  def new
    @question = Question.new
    @question.attachments.build
  end

  def edit
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Question successfully created'
    else
      render :new
    end
  end

  def destroy
    if current_user.author_of?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Question successfully deleted.'
    else
      redirect_to question_path(@question), alert: "You can not remove a foreign question!"
    end
  end

  private

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast 'questions',
    ApplicationController.render(
      partial: 'questions/question',
      locals: { question: @question }
      )
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
