module Rates
  extend ActiveSupport::Concern

  included do
    before_action :set_ratable, only: [:rate_up, :rate_down]
  end

  def rate_up
    error = @ratable.rate_up(current_user)

    if error[0] == false
      render json: error, status: :forbidden
    else
      render json: {show_rate: @ratable.show_rate}
    end
  end

  def rate_down
    error = @ratable.rate_down(current_user)

    if error[0] == false
      render json: error, status: :forbidden
    else
      render json: {show_rate: @ratable.show_rate}
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_ratable
    @ratable = model_klass.find(params[:id])
  end
end
