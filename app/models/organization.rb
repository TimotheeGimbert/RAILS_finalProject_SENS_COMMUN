class Organization < ApplicationRecord
  belongs_to :city
  belongs_to :status
  belongs_to :activity_sector
  has_many :legal_reps
  has_many :managers, through: :legal_reps, source: :user
  has_many :external_stakeholders
  has_many :users, through: :external_stakeholders
  has_many :activities
end
