class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: [ :new, :login ]
  def new
  end
  def login
    @user = User.find_by_username(params[:username])
    if @user&.authenticate(params[:password])
    token = JsonWebToken.encode(user_id: @user.id)
    time = Time.now + 24.hours.to_i
    respond_to do |format|
      format.json do
        render json: { token: token, exp: time.strftime("%m-%d-%Y %H:%M"), username: @user.username }, status: :ok
      end

      format.html do
          session[:user_id] = @user.id
          cookies[:jwt_token] = token
          redirect_to api_v1_customers_path, notice: "Sesión iniciada correctamente"
        end
      end
    else
      respond_to do |format|
        format.json { render json: { error: "Usuario o contraseña incorrectos" }, status: :unauthorized }
        format.html { flash.now[:alert] = "Credenciales inválidas"; render :new, status: :unauthorized }
      end
    end
  end

  def logout
   token = request.headers["Authorization"]&.split(" ")&.last || cookies[:jwt_token]

  if token
    # Registramos el token en la lista negra para invalidarlo
    BlacklistedToken.create!(token: token)
  end

  # Limpiamos rastro en el navegador
  cookies.delete(:jwt_token)
  session[:user_id] = nil

  respond_to do |format|
    format.json { render json: { message: "Sesión cerrada" }, status: :ok }
    format.html { redirect_to root_path, notice: "Has salido del sistema" }
  end
  end
end
