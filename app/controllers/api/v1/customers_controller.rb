class Api::V1::CustomersController < ApplicationController
  before_action :authorize_request
  before_action :set_customer, only: [ :show, :update, :destroy, :edit ]


  def index
    @customers = Customer.includes(registrations: :user)

    respond_to do |format|
      format.json do
        render json: @customers.as_json(
          methods: :creator_user,
          except: [ :password_digest, :created_at, :updated_at ]
        )
      end
      format.html
    end
  end


  def show
    respond_to do |format|
      format.json { render json: @customer.as_json(methods: :creator_user) }
      format.html { render partial: "customer_details", locals: { customer: @customer } }
    end
  end

  def new
    @customer = Customer.new(person_type: "natural")
  end
  def create
    @customer = Customer.new(customer_params)

    ActiveRecord::Base.transaction do
      if @customer.save
        @customer.registrations.create!(
          registration_date: Date.current,
          user_id: @current_user.id
        )
        respond_to do |format|
          format.json { render json: @customer, status: :created }
          format.html { redirect_to api_v1_customers_path, notice: "Cliente creado exitosamente." }
        end
      else
        respond_to do |format|
          format.json { render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity }
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.message }, status: :unprocessable_entity
  end

  def edit
      @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    # Rails.logger.debug "---------------------------------------"
    # Rails.logger.debug "PARAMS: #{params.inspect}"
    # Rails.logger.debug "USUARIO ACTUAL: #{@current_user.username}"
    # Rails.logger.debug "---------------------------------------"
    if @customer.update(customer_params)
      respond_to do |format|
        format.json { render json: @customer, status: :ok }
        format.html { redirect_to edit_api_v1_customer_path(@customer), notice: "Cliente actualizado correctamente." }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @customer.update(deleted: true)
      respond_to do |format|
        format.json { render json: { message: "Cliente eliminado" }, status: :ok }
        format.html { redirect_to api_v1_customers_path, notice: "Cliente eliminado correctamente." }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity }
        format.html { redirect_to api_v1_customers_path, alert: "No se pudo eliminar el cliente." }
      end
    end
  end

  def restore
    @customer = Customer.find(params[:id])
    if @customer.update(deleted: false)
      respond_to do |format|
        format.json { render json: { message: "Cliente activado" }, status: :ok }
        format.html { redirect_to api_v1_customers_path, notice: "Cliente activado exitosamente." }
      end
    else
      respond_to do |format|
        format.json { render json: { errors: @customer.errors.full_messages }, status: :unprocessable_entity }
        format.html { redirect_to api_v1_customers_path, alert: "No se pudo activar el cliente." }
      end
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Customer no encontrado" }, status: :not_found
  end

  def customer_params
    params.require(:customer).permit(
        :full_name,
        :email,
        :id_number,
        :phone_primary,
        :phone_secondary,
        :person_type,
        :expiry_date,
        :issue_date,
        :deleted
      )
  end
end
