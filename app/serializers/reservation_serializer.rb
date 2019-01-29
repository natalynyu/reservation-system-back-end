class ReservationSerializer < ActiveModel::Serializer
  attributes :id, :start_time, :end_time, :machine, :doctor_id
end
