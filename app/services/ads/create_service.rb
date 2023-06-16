module Ads
  class CreateService
    prepend BasicService

    option :ad do
      option :title
      option :description
      option :city
    end

    option :user_id

    option :coordinates do
      option :lat, optional: true
      option :lon, optional: true
    end

    attr_reader :ad

    def call
      @ad = ::Ad.new(@ad.to_h)
      @ad.user_id = @user_id
      @ad.lat = @coordinates.lat
      @ad.lon = @coordinates.lon

      if @ad.valid?
        @ad.save
      else
        fail!(@ad.errors)
      end
    end
  end
end
