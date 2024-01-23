@users = 1.upto(10).map { |_i| User.create!(name: Faker::Name.first_name, last_name: Faker::Name.last_name, password: Faker::Internet.password, email: Faker::Internet.email) }

@categories = 1.upto(10).map { |i| Category.create(description: "category #{i}", code: Faker::Number.number(8), user: User.find(@users.map(&:id).sample)) }

@products = @categories.map do |category|
  quantity = rand(10)
  (1..quantity).map do |_i|
    Product.create!(
      title: Faker::Commerce.product_name,
      code: Faker::Number.number(8),
      sell_price: Faker::Number.positive,
      description: Faker::Commerce.product_name,
      cost: Faker::Number.positive,
      weight: Faker::Number.positive,
      width: Faker::Number.positive,
      length: Faker::Number.positive,
      height: Faker::Number.positive,
      user: User.find(@users.map(&:id).sample),
      category_items_attributes: [{ category_id: category.id }]
    )
  end
end.flatten

@clients = 1.upto(30).map do |_i|
  Client.create(
    name:   Faker::Commerce.product_name,
    last_name:   Faker::Commerce.product_name,
    doc_number: Faker::Number.number(8),
    email:  Faker::Internet.email,
    phone: Faker::Number.number(8),
    zip_code: Faker::Number.number(4),
    address: Faker::Address.full_address,
    user:  User.find(@users.map(&:id).sample)
  )
end

@orders = @products.each do |product|
  quantity = rand(20)
  (1..quantity).map do |_i|
    Order.create!(
      code:  Faker::Number.number(8),
      status:  'new',
      payment_method: Faker::Commerce.product_name,
      shipping_method: Faker::Commerce.product_name,
      shipping_price: Faker::Number.positive.to_i,
      total_price: Faker::Number.positive,
      product: product,
      client: Client.find(@clients.map(&:id).sample)
    )
  end
end.flatten
