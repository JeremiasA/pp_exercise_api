class CategoryItem < ActiveRecord::Base
  belongs_to :category
  belongs_to :product, inverse_of: :category_items

  validates :product, presence: true
  validates :category, presence: true
  validates :category_id, uniqueness: { scope: [:product_id] }

  after_save :verify_item_already_exists

  private

  def verify_item_already_exists
    return unless @category_items_created_from_product
    return unless product.category_items.where(category_id: category_id).exists?

    false
  end
end
