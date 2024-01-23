class User < ActiveRecord::Base
  include SecurePasswordConcern
  include AuthenticableConcern

  has_secure_password

  has_many :clients
  has_many :categories
  has_many :products

  validates_presence_of :name
  validates_presence_of :last_name
  validates_presence_of :email
  validates_presence_of :password

  validates_uniqueness_of :email
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  def self.authenticate_by_email(email)
    where(email: email).first
  end

  def self.authenticate_by_email_and_pass(email, password)
    return if email.blank?
    return if password.blank?

    user = authenticate_by_email(email)
    return unless user

    return unless user.try(:authenticate, password)

    user
  end
end
