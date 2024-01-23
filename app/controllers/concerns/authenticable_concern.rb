# frozen_string_literal: true

module AuthenticableConcern
  extend ActiveSupport::Concern

  included do
    def self.basic_authenticate!(params = {})
      around_action :basic_authenticate!, params
    end

    private

    def basic_authenticate!
      return bad_request_error unless request.authorization.to_s.starts_with? 'Basic'

      @current_user = User.authenticate_by_email_and_pass(*user_name_and_password)
    end

    def user_name_and_password
      @user_name_and_password ||= begin
        email, pwd = ActionController::HttpAuthentication::Basic.user_name_and_password(request)

        [email.downcase.strip, pwd]
      end
    end
  end
  end
