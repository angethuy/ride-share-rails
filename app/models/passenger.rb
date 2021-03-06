class Passenger < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  validates :phone_num, presence: true

  def total_spent 
    return trips.map { |trip| trip.rating.nil? ? 0 : trip.cost}.sum 
  end

  def has_inprogress_trip? 
    return !(trips.empty?) && trips.last.rating.nil?
  end
  
end
