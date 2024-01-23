class Product < ActiveRecord::Base
  validates_presence_of :code
  validates_presence_of :title
  validates_uniqueness_of :code

  attr_accessor :categories_ids

  belongs_to :user

  has_many :orders
  has_many :category_items, inverse_of: :product, after_add: :set_category_items_flag, after_remove: :set_category_items_flag
  has_many :categories, through: :category_items, dependent: :destroy

  accepts_nested_attributes_for :category_items

  validate :validate_category_items

  private

  def set_category_items_flag(active)
    @category_items_created_from_product = active
  end

  def validate_category_items
    return unless @category_items_created_from_product || new_record?

    validate_category_items_presence
  end

  def validate_category_items_presence
    return unless category_items.any? do |item|
                    item.changed? || item.destroyed?
                  end || (new_record? && category_items.blank?)

    return if category_items.present?

    errors.add(:category_items, :blank)
  end
end
