require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  before do
    allow_any_instance_of(Order).to receive(:send_first_product_sold_email!).and_return(nil)
    controller.request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials(token)
  end

  user = User.last
  # token = JWT.encode({ user_id: user.id }, "secret")
  let(:token) { 'eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxfQ.w797lHrs1R0WUKr6PueEbleaHuGJGPFhSp2Ix95wrL8' }
  # headers = { 'Authorization' => "Bearer #{token}" }
  # let (:headers) {{ 'Authorization' => "Bearer #{token}" } }
  let (:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe '#create' do
    let(:http_request) do
      post :create, body.merge!(format: :json), headers, as: :json
    end

    let(:body) { params }
    let(:subject) { http_request }

    describe 'with valid body' do
      let(:params) do
        {
          code: Faker::Code.npi.to_s,
          status: 'new',
          payment_method: 'bank_transfer',
          shipping_method: 'door_to_door',
          shipping_price: 1234.to_f,
          product_id:  1,
          client_id: 1
        }
      end

      it 'creates an order' do
        expect do
          subject
        end.to change { Order.count }
      end

      it 'responds with 201' do
        subject

        assert_response 201
      end

      it 'sets correct values' do
        subject

        created_order = Order.where(code: body[:code]).first

        params.each do |key, value|
          next if [:total_price, :format].include?(key)
          expect(created_order[key]).to eq(value)
        end

        expect(created_order[:total_price]).to eq(created_order[:shipping_price] + created_order.product.sell_price)
      end
    end

    describe 'with params missing' do
      let(:params) do
        {
          status: 'new',
          payment_method: 'bank_transfer',
          shipping_method: 'door_to_door',
          shipping_price: 1234.to_f,
          product_id:  1,
          client_id: 1
        }
      end

      it 'does not create a order' do
        code = nil
        expect do
          subject
        end.to_not change { Order.count }
      end

      it 'responds with 422' do
        subject
        assert_response 422
      end

      it 'raise exception' do
        subject

        expect(response.message).to eq('Unprocessable Entity')
      end
      describe 'with duplicated code' do
        let(:params) do
          {
            code: Order.last.code,
            status: 'new',
            payment_method: 'bank_transfer',
            shipping_method: 'door_to_door',
            shipping_price: 1234.to_f,
            product_id:  Product.last.id,
            client_id: Client.last.id
          }
        end

        it 'does not create a order' do
          code = nil
          expect do
            subject
          end.to_not change { Order.count }
        end

        it 'responds with 422' do
          subject
          assert_response 422
        end

        it 'raise exception' do
          subject

          expect(response.message).to eq('Unprocessable Entity')
        end
      end
    end
  end

  describe '#update' do
    let(:http_request) do
      put :update, body.merge!(format: :json), as: :json
    end

    let(:body) { params }
    let(:subject) { http_request }

    let(:order) { Order.last }

    describe 'with valid body' do
      let(:params) do
        {
          id: order.id,
          payment_method: 'bank_transfer',
          shipping_method: 'new_method'
        }
      end

      it 'updates an order' do
        expect do
          subject
        end.to_not change { Order.count }
      end

      it 'responds with 200' do
        subject

        assert_response 200
      end

      it 'sets correct values' do
        subject

        order.reload

        params.each do |key, value|
          next if [:total_price, :format].include?(key)
          expect(order[key]).to eq(value)
        end
      end
    end
  end

  describe 'with filters' do
    let(:http_request) do
      get :index, params, headers: headers
    end

    let(:params) { q_params }
    let(:subject) { http_request }

    describe 'with user filter' do
      let(:json_response) { JSON.parse(response.body) }
      let(:q_params) { { user_id: user.id } }

      it 'returns by user' do
        subject

        orders_ids = json_response['results'].map { |order| order['id'] }

        expect(Product.joins(:orders).where(orders: { id: orders_ids }).map(&:user_id)).to all(eq(user.id))
      end
    end

    describe 'with dates filter' do
      let(:json_response) { JSON.parse(response.body) }
      let(:q_params) { { created_from: (Time.current - 5.hours), created_to: Time.current } }

      it 'returns orders between dates' do
        subject

        orders = json_response['results']

        expect(orders.map { |order| order['created_at'].to_time.iso8601(3) }).to all(be <= Time.current.iso8601(3))
        expect(orders.map { |order| order['created_at'].to_time.iso8601(3) }).to all(be >= (Time.current - 5.hours).iso8601(3))
      end
    end

    describe 'with granularity filter' do
      let(:json_response) { JSON.parse(response.body) }
      let(:q_params) { { count_by_range: 'hour' } }

      it 'returns by hour granularity' do
        subject

        dates = json_response['stats'].keys

        (0..(dates.size - 2)).each do |i|
          expect(dates[i].to_time + 1.hour).to eq(dates[i + 1].to_time)
        end
      end
    end
  end
end
