class Api::V1::TradesController < Api::V1::BaseController
  # doorkeeper_for :all

  helper_method :selected_scope

  respond_to :json

  # GET /trades.json
  def index
    respond_with @trades = Trade.send(selected_scope)
  end

  # GET /trades/1.json
  def show
    respond_with @trade = Trade.find(params[:id])
  end


private

  # Returns selected scope via param of default
  def selected_scope
    (params[:scope] || :default).to_sym
  end

end
