class Driver < ApplicationRecord
  has_many :trips
  validates :name, presence: true
  validates :vin, presence: true

  def average_rating
    return trips.empty? ? 0 : calculate_rating
  end

  def earnings
    return trips.map { |trip| trip.rating.nil? ? 0 : (trip.cost - 1.65) * 0.8}.sum 
  end

  private 

  def calculate_rating
    ratings_total = trips.map { |trip| trip.rating.nil? ? 0 : trip.rating }.sum
    return (ratings_total.to_f / trips.length).round(2)
  end

end

