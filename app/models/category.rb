class Category < ActiveRecord::Base
  belongs_to :user

  has_many :category_items
  has_many :products, through: :category_items

  validates_presence_of :code
  validates_presence_of :description
  validates_length_of :description, maximum: 50
  validates_uniqueness_of :code

  private
end
