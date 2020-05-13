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

  def has_inprogress_trip? 
    return !(trips.empty?) && trips.last.rating.nil?
  end

  def self.get_next_available
    all_available_drivers = Driver.where(:available => true).joins(:trips).order('date DESC').uniq + Driver.where(:available => true).includes(:trips).where(trips: {driver_id: nil}).reverse
    return all_available_drivers.empty? ? nil : all_available_drivers.last
  end

  def self.any_available?
    return !Driver.where(:available => true).empty?
  end

  private 

  def calculate_rating
    ratings_total = trips.map { |trip| trip.rating.nil? ? 0 : trip.rating }.sum
    return (ratings_total.to_f / trips.length).round(2)
  end

end

