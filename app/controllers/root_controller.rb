class RootController < ApplicationController

  respond_to :json

  # GET /
  def index
    render json: {}, status: :ok
  end

end
