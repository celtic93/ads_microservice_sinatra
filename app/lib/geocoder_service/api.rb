# frozen_string_literal: true

module GeocoderService
  module Api
    def get_coordinates(city)
      response = connection.get do |request|
        request.params[:city] = city
        request.headers['X-Request-Id'] = Thread.current[:request_id]
      end

      response.success? ? response.body['data'] : {}
    end
  end
end
