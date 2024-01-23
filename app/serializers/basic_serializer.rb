# frozen_string_literal: true

module BasicSerializer
  def render(resource, options = {})
    json(resource, options)
  end

  def render_many(resources, options = {})
    options[:includes] ||= includes_options(resources, options)
    resources.map do |resource|
      json(resource, options)
    end
  end

  def excludes_nested_params(options, nested_key)
    options.fetch(:excludes, []).flat_map do |h|
      h.is_a?(Hash) ? h.fetch(nested_key, []) : []
    end
  end

  def includes_options(_resources, _options)
    {}
  end
  end
