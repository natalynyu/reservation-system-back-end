class Reservation < ApplicationRecord
  belongs_to :doctor
  validates :machine, presence: true
end
