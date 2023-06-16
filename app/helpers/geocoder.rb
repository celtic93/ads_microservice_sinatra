# frozen_string_literal: true

module Geocoder
  def coordinates
    geocoder_service.get_coordinates(city)
  end

  private

  def geocoder_service
    @geocoder_service ||= GeocoderService::Client.new
  end

  def city
    request.params['ad']['city']
  end
end
