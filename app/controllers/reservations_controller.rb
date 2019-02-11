# frozen_string_literal: true

class ReservationsController < ProtectedController
  before_action :set_doctor
  before_action :set_reservation, only: %i[show update destroy]

  # GET /reservations
  def index
    # find doctor record from @current_user
    # find reservation records where doctor_id is equal to current doctor id
    @reservations = Reservation.where(doctor_id: @doctor.id)
    render json: @reservations
  end

  # GET /reservations/1
  def show
    render json: @reservation
  end

  # POST /reservations
  def create
    if @doctor.nil?
      render json: { reservation: 'cannot be created before doctor info is entered' }, status: :unprocessable_entity
      return
    end
    rp = reservation_params
    machine = rp[:machine]
    start_time = rp[:start_time]
    end_time = rp[:end_time]
    # NOTE: (some expression) OR (some other expression)
    # like (machine = ? and start_time = ?) or (machine = ? and start_time < ?)
    reservations = Reservation.where(
      'machine = :machine and :end_time > start_time and
        :start_time < end_time',
      machine: machine, start_time: start_time, end_time: end_time
    )
    if reservations.any?
      render json: { reservation: 'already exists' }, status: :unprocessable_entity
      return
    end
    rp[:doctor_id] = @doctor.id
    @reservation = Reservation.new(rp)

    if @reservation.save
      render json: @reservation, status: :created, location: @reservation
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /reservations/1
  def update
    rp = reservation_params
    if @reservation.update(reservation_params)
      render json: @reservation
    else
      render json: @reservation.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reservations/1
  def destroy
    @reservation.destroy
  end

  private

  def set_doctor
    @doctor = Doctor.find_by(user_id: @current_user.id)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_reservation
    return if @doctor.nil?

    @reservation = @doctor.reservations.find(params[:id])
    # @reservation = @current_user.doctorsReservation.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  # {reservation: {start_time: , end}}
  def reservation_params
    params.require(:reservation).permit(:start_time, :end_time, :machine)
  end
end
