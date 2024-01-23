# frozen_string_literal: true

module SerializationConcern
  extend ActiveSupport::Concern

  private

  def render_one(resource, options)
    render json: serialize_one(resource, options), status: options.fetch(:status, :ok)
  end

  def render_many(resources, options)
    render json: serialize_many(resources, options.merge(status: :ok))
  end

  def render_create(resource, options)
    render_one resource, options.merge(status: :created)
  end

  def render_show(resources, options)
    if resources.is_a?(Enumerable)
      render_many(resources, options)
    else
      render_one(resources, options)
    end
  end

  def serialization_options(options)
    fields = options[:fields] || []
    excludes = options[:excludes] || []

    options.merge(
      fields: fields,
      excludes: excludes,
      params: params
    )
  end

  def serialize_many(resources, options)
    {
      results: options.fetch(:with).render_many(resources, options)
    }
  end

  def serialize_one(resource, options)
    options = serialization_options(options)

    options.fetch(:with).render(resource, options)
  end

  def location_params
    nil
  end
end
