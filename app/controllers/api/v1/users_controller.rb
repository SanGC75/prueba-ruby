class Api::V1::UsersController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
