# frozen_string_literal: true

module GeocoderService
  module Api
    def get_coordinates(city)
      response = connection.get do |request|
        request.params[:city] = city
      end

      response.success? ? response.body['data'] : {}
    end
  end
end
