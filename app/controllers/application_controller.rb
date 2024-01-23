class ApplicationController < ActionController::Base
  require 'will_paginate'

  include ErrorHandlingConcern
  include SerializationConcern
  include AuthenticableConcern

  JWT_SECRET = ENV['JWT_SECRET']
  PER_PAGE_FIXED_PARAM = 25

  before_filter :authorized, :page, :per_page

  def raise_not_found!
    raise ActionController::RoutingError, "No route matches #{params[:unmatched_route]}"
  end

  def encode_token(payload)
    JWT.encode(payload, JWT_SECRET)  
  end

  def decoded_token
    header = request.headers['Authorization']
    if header
      token = header.split(' ')[1]
      begin
        JWT.decode(token, JWT_SECRET )
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']

      @user = User.first
    end
  end

  def authorized
    unless !!current_user
      render json: { message: 'Please log in' }, status: :unauthorized
    end
  end

  def page
    request.params[:page] = 1 unless request.params[:page]
  end

  def per_page
    PER_PAGE_FIXED_PARAM
  end
end
