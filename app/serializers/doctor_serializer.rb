class DoctorSerializer < ActiveModel::Serializer
  attributes :id, :full_name, :department, :user
end
