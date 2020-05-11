class Trip < ApplicationRecord
  belongs_to :driver
  belongs_to :passenger

  # https://stackoverflow.com/questions/24279948/rails-validate-only-on-create-or-on-update-when-field-is-not-blank
  validates :rating, numericality: { only_integer: true, greater_than: 0, less_than: 6 }, allow_blank: true
end
