class Order < ActiveRecord::Base
  include Filterable
  include Filterable::OrderFilter

  STATUSES = %w(
    new
    on_hold
    completed
    cancelled
  ).freeze

  belongs_to :product
  belongs_to :client

  has_one :user, through: :product
  has_many :category_items, through: :product, source: :category_items

  validates_presence_of :code
  validates_presence_of :status
  validates_presence_of :payment_method
  validates_presence_of :shipping_method
  validates_presence_of :shipping_price

  validates_uniqueness_of :code

  validates :product, presence: true
  validates :client, presence: true
  validate :validate_status

  before_save :set_total_price

  after_commit :send_first_product_sold_email!, on: :create

  private

  def set_total_price
    return unless shipping_price_changed?

    self.total_price = shipping_price + product.sell_price
  end

  def validate_status
    return unless status_changed?

    return if STATUSES.include?(status)

    errors.add(:status, "should be one of #{STATUSES}")
  end

  def send_first_product_sold_email!
    # avoid enqueuing if orders created befor 1 milisecond from now exists
    return if previous_order_exists?

    FirstProductSoldEmailSenderJob.perform_async(product_id)
  end

  def previous_order_exists?
    Order.where('id != ?', id)
         .where(
           product_id: product_id,
           created_at: (
                 format_date(Order.minimum(:created_at))..
                 format_date((created_at.to_time - 1 / 1001.0))
           )
         ).exists?
  end

  def format_date(date)
    date.iso8601(3)
  end
end
