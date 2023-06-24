#todo remove before pushing to production
class CorsMiddleware
  #uncomment during testing
  def initialize(app)
    @app = app
  end

  def call(env)
    headers = {
      'Access-Control-Allow-Origin' => %w[http://localhost:63342 https://workout.exequte.cn], # Replace this with the appropriate origin(s) that should have access
      'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS',
      'Access-Control-Allow-Headers' => 'Origin, Content-Type, Accept, Authorization',
      'Access-Control-Allow-Credentials' => 'true'
    }

    if env['REQUEST_METHOD'] == 'OPTIONS'
      headers['Access-Control-Max-Age'] = '1728000'
      headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type, Accept, Origin, User-Agent, Cache-Control, X-Requested-With'
      headers['Access-Control-Allow-Methods'] = 'GET, POST, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Origin'] = %w[http://localhost:63342 https://workout.exequte.cn] # Replace this with the appropriate origin(s) that should have access

      return [200, headers, []]
    end

    @app.call(env).tap do |response|
      response[1].merge!(headers)
    end
  end
end

puts "add cors exception"
Rails.application.config.middleware.insert_before 0, CorsMiddleware


