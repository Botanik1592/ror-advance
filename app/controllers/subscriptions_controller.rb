class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: :create
  authorize_resource

  def create
    @subscription = current_user.subscriptions.create(question_id: @question.id)
    redirect_to question_path(@question), notice: 'Subscribe to the question successfully created'
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
    redirect_to question_path(@subscription.question), notice: 'Subscribe to the question successfully canceled'
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
