class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
  before_action :authorize_request
  layout "application"
  def authorize_request
    auth_header = request.headers["Authorization"] || cookies[:jwt_token]
    token = auth_header.split(" ").last if auth_header
    if token.nil? || BlacklistedToken.exists?(token: token)
      render json: { error: "Token inválido o sesión cerrada" }, status: :unauthorized
      return
    end

    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render_unauthorized("No autorizado")
    end
  end

private

  def render_unauthorized(message)
    respond_to do |format|
      format.json { render json: { error: message }, status: :unauthorized }
      format.html do
        redirect_to root_path, alert: message unless action_name == "new"
      end
    end
  end
end
