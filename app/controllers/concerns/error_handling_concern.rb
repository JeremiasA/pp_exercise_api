# frozen_string_literal: true

module ErrorHandlingConcern
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActionController::ParameterMissing, with: :parameter_missing_exception
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from ActionController::RoutingError, with: :routing_error
    rescue_from ArgumentError, with: :argument_error
  end

  private

  def bash_exception(exception)
    # errors = exception.errors.map do |error|
    #  {
    #    title: error[:title],
    #    detail: error.fetch(:error).message
    #  }.compact
    # end
    #
    # unprocessable_entity_errors(errors)
  end

  def record_invalid(exception)
    errors = exception.record.errors.to_hash.flat_map do |k, v|
      v.map do |msg|
        {
          attribute: k,
          detail: msg
        }
      end
    end

    unprocessable_entity_errors(errors)
  end

  def range_error(exception)
    raise exception unless exception.message.match?(/is out of range for activemodel..type..integer/i)

    errors = [
      {
        status: 422,
        title: 'Unprocessable Entity',
        detail: "#{exception.message[/^\d+/]} is out of range for integer type"
      }
    ]

    unprocessable_entity_errors(errors)
  end

  def routing_error(exception)
    errors =
      {
        status: 400,
        title: 'Bad request',
        detail: exception.message
      }

    bad_request_error(detail: exception.message)
  end

  def argument_error(exception)
    # Solo devolver error al cliente si viene por un valor invalido para un enum.
    raise exception unless exception.message.include?('is not a valid')

    errors = [
      {
        status: 422,
        title: 'Unprocessable Entity',
        detail: exception.message
      }
    ]

    unprocessable_entity_errors(errors)
  end

  #
  # def record_not_found_message(exception)
  #  debugger
  #  model_name = exception.model || params[:controller]
  #  model_name = model_name.singularize.underscore
  #
  #  detail = "Couldn't find #{model_name}"
  #  if exception.primary_key.present? && exception.id.present?
  #    detail += " with #{exception.primary_key} = '#{exception.id}'"
  #  end
  #
  #  detail
  # end
  #
  def record_not_found(exception)
    not_found_error(
      detail: exception.message
    )
  end

  def invalid_foreign_key_error(exception)
    unprocessable_entity_error(
      detail: record_not_found_message(exception)
    )
  end

  def parameter_missing_exception(exception)
    bad_request_error(detail: exception.message)
  end

  def bad_request_exception(exception)
    bad_request_error(detail: exception.message)
  end

  def unprocessable_entity_exception(exception)
    unprocessable_entity_error(detail: exception.message)
  end

  def unauthorized_exception(exception)
    unauthorized_error(detail: exception.message)
  end

  def forbidden_exception(exception)
    forbidden_error(detail: exception.message)
  end

  def rate_limit_exceeded_exception(exception)
    too_many_requests_error(detail: exception.message)
  end

  def bad_request_error(error = {})
    @error = {
      status: 400,
      title: 'Bad Request'
    }.merge!(error)

    render 'errors/show', status: :bad_request
  end

  def unauthorized_error(error = {})
    @error = {
      status: 401,
      title: 'Unauthorized'
    }.merge!(error)

    render 'errors/show', status: :unauthorized
  end

  def forbidden_error(error = {})
    @error = {
      status: 403,
      title: 'Forbidden'
    }.merge!(error)

    render 'errors/show', status: :forbidden
  end

  def not_found_error(error = {})
    @error = {
      status: 404,
      title: 'Not Found'
    }.merge!(error)

    render 'errors/show', status: :not_found
  end

  def unprocessable_entity_error(error = {})
    @error = {
      status: 422,
      title: 'Unprocessable Entity'
    }.merge!(error)

    render 'errors/show', status: :unprocessable_entity
  end

  def unprocessable_entity_errors(errors = [])
    @errors = errors.map do |error|
      {
        status: 422,
        title: 'Unprocessable Entity'
      }.merge!(error)
    end

    render 'errors/index', status: :unprocessable_entity
  end
  end
