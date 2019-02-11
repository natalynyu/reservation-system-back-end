# frozen_string_literal: true

class DoctorsController < ProtectedController
  before_action :set_doctor, only: %i[show update destroy]

  # GET /doctors
  def index
    @doctors = Doctor.all

    render json: @doctors
  end

  # GET /doctors/1
  def show
    render json: @doctor
  end

  # POST /doctors
  def create
    p = doctor_params
    p[:user_id] = @current_user.id
    @doctor = Doctor.new(p)

    if @doctor.save
      render json: @doctor, status: :created, location: @doctor
    else
      render json: @doctor.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /doctors/1
  def update
    p = doctor_params
    p[:user_id] = @current_user.id
    if @doctor.update(p)
      render json: @doctor
    else
      render json: @doctor.errors, status: :unprocessable_entity
    end
  end

  # DELETE /doctors/1
  def destroy
    @doctor.destroy
  end

  def update_info
    @doctor = Doctor.find_by(user_id: @current_user.id)
    if @doctor
      update
    else
      create
    end
  end

  def get_info
    doctor = Doctor.find_by(user_id: @current_user.id)
    if doctor.nil?
      render nothing: true, status: 204
    else
      render json: doctor
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_doctor
    @doctor = @current_user.doctors.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def doctor_params
    params.require(:doctor).permit(:full_name, :department)
  end
end
