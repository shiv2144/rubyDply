class Api::V1::UsersController < Api::V1::BaseController
  doorkeeper_for :all

  respond_to :json

  def index
    respond_with @users = User.all
  end

  def show
    respond_with current_user
  end
  alias_method :me, :show

end
