class Client < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :name
  validates_presence_of :last_name
  validates_presence_of :doc_number
  validates_presence_of :email
  validates_presence_of :phone
  validates_presence_of :zip_code
  validates_presence_of :address

  validates_uniqueness_of :email

  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  private
end
