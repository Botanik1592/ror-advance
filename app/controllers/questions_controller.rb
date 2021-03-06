class QuestionsController < ApplicationController
  include Rates

  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_question, except: [:index, :new, :create]
  before_action :build_answer, only: [:show]
  after_action :publish_question, only: [:create]

  respond_to :js, only: :update

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    @subscription = current_user.subscriptions.try(:find_by_question_id, @question) if current_user
    respond_with(@question, @answer)
  end

  def new
    respond_with(@question = Question.new)
  end

  def edit
  end

  def update
    @question.update(question_params) if current_user.author_of?(@question)
    respond_with @question
  end

  def create
    respond_with(@question = current_user.questions.create(question_params))
  end

  def destroy
    respond_with @question.destroy if current_user.author_of?(@question)
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

  def build_answer
    @answer = @question.answers.build
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
