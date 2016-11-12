module Rates
  extend ActiveSupport::Concern

  included do
    before_action :set_ratable, only: [:rate_up, :rate_down]
  end

  def rate_up
    @ratable.rate_up(current_user)
    render json: {show_rate: @ratable.show_rate}.to_json
  end

  def rate_down
    @ratable.rate_down(current_user)
    render json: {show_rate: @ratable.show_rate}.to_json
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def set_ratable
    @ratable = model_klass.find(params[:id])
  end
end
