class Api::V1::JobTypesController < Api::V1::BaseController
  # doorkeeper_for :all
  before_action :set_trade, only: [:index]

  helper_method :selected_scope

  respond_to :json

  # GET /job_types.json
  def index
    if @trade
      @job_types = @trade.job_types
    else
      @job_types = JobType.defaults
    end
    respond_with @job_types
  end

  # GET /job_types/1.json
  def show
    respond_with @job_type = Jobtype.find(params[:id])
  end


private

  # Sets trade if trade_id param exists
  def set_trade
    @trade = Trade.find(params[:trade_id]) if params[:trade_id]
  end

end
