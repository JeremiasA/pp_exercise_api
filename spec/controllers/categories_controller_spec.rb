require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  before do
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

    let(:body) { { code: code, description: description } }
    let(:subject) { http_request }

    describe 'with valid body' do
      let(:code) { Faker::Code.npi }
      let(:description) { Faker::Code.npi }

      it 'creates a category' do
        expect do
          subject
        end.to change { Category.count }
      end

      it 'responds with 201' do
        subject

        assert_response 201
      end

      it 'sets correct values' do
        subject

        created_category = Category.where(code: body[:code]).first

        expect(created_category.description).to eq(body[:description])
      end
    end

    describe 'with params missing' do
      let(:code) { nil }
      let(:description) { Faker::Code.npi }

      it 'does not create a category' do
        expect do
          subject
        end.to_not change { Category.count }
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
