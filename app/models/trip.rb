class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  # https://stackoverflow.com/questions/24279948/rails-validate-only-on-create-or-on-update-when-field-is-not-blank
  validates :rating, numericality: { only_integer: true, greater_than: 0, less_than: 6 }, allow_blank: true

  def paid_to_driver 
    return ([cost - 1.65, 0].max * 0.8).round(2)
  end

  def profit 
    return (cost - paid_to_driver).round(2)
  end
end
