class AddDoctorToReservations < ActiveRecord::Migration[5.2]
  def change
    add_reference :reservations, :doctor, foreign_key: true
  end
end
