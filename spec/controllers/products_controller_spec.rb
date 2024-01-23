require 'rails_helper'

RSpec.describe Api::V1::ProductsController, type: :controller do
  before do
    controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(token)
  end

  user = User.last
  token = JWT.encode({ user_id: user.id }, 'secret')
  headers = { 'Authorization' => "Bearer #{token}" }
  let (:headers) { { 'Authorization' => "Bearer #{token}" } }
  let (:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe '#most_sold_products' do
    let(:http_request) do
      get :most_sold_products, headers: headers
    end

    let(:subject) { http_request }
    let(:results) { JSON.parse(response.body) }

    it 'should returns an Array' do
      subject

      expect(results['products']).to be_a_kind_of(Array)
    end

    it 'should has correct quantities' do
      subject

      results['products'].each do |result|
        expect(Order.where(product_id: result['product_id']).count).to eq(result['orders_count'].to_i)
      end
    end

    it 'should order quantities from greather to less' do
      subject

      categories_codes = results['products'].map { |r| r['category'] }.uniq

      categories_codes.each do |category_code|
        category_products = results['products'].select { |r| r['category'] == category_code }

        products_ids = category_products.map { |r| r['product_id'] }
        expect(CategoryItem.joins(:category).where(categories: { code: category_code }, product_id: products_ids)).to exist

        # totals are orderer from greather to less
        orders_sold_quantities = category_products.map { |r| r['orders_count'].to_i }

        expect(orders_sold_quantities).to eq(orders_sold_quantities.sort.reverse!)
        (0..(orders_sold_quantities.size - 1)).each do |i|
          expect(orders_sold_quantities[i]).to be >= (orders_sold_quantities[i])
        end
      end
    end
  end

  describe '#most_money_products' do
    let(:http_request) do
      get :most_money_products, headers: headers
    end

    let(:subject) { http_request }
    let(:results) { JSON.parse(response.body) }

    it 'should returns an Array' do
      subject

      expect(results['products']).to be_a_kind_of(Array)
    end

    it 'should has correct money totals' do
      subject

      results['products'].each do |result|
        expect(Product.joins(:orders).where(id: result['product_id']).sum(:sell_price).to_f).to eq(result['product_price_totals'].to_f)
      end
    end

    it 'should order money totals from greather to less' do
      subject

      categories_codes = results['products'].map { |r| r['category'] }.uniq

      categories_codes.each do |category_code|
        category_products = results['products'].select { |r| r['category'] == category_code }

        products_ids = category_products.map { |r| r['product_id'] }
        expect(CategoryItem.joins(:category).where(categories: { code: category_code }, product_id: products_ids)).to exist

        # totals are orderer from greather to less
        orders_sold_quantities = category_products.map { |r| r['product_price_totals'].to_i }

        expect(orders_sold_quantities).to eq(orders_sold_quantities.sort.reverse!)
        (0..(orders_sold_quantities.size - 2)).each do |i|
          expect(orders_sold_quantities[i]).to be >= (orders_sold_quantities[i + 1])
        end
      end
    end
  end
end
