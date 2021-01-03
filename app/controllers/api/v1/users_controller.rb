class Api::V1::UsersController < Api::V1::BaseController
  def index
    @users = User.where.not(id: current_resource_owner.id)
    render json: @users
  end
end
