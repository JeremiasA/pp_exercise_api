class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue JSON::ParserError => error
    if env['CONTENT_TYPE'] =~ /application\/json/
      error_output = "There was a problem in the JSON you submitted: #{error.message}"
      return [
        400, { 'Content-Type' => 'application/json' },
        [{ status: 400, error: error.message }.to_json]
      ]
    else
      raise error
    end
  end
end
