require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================
    raw_data = open("http://maps.googleapis.com/maps/api/geocode/json?address="+url_safe_street_address).read
    require 'json'
    parsed_data1 = JSON.parse(raw_data)

    @lat = parsed_data1["results"][0]["geometry"]["location"]["lat"].to_s
    @lng = parsed_data1["results"][0]["geometry"]["location"]["lng"].to_s

    raw_data = open("https://api.forecast.io/forecast/18a09883e6f92ed631b83d4b80a6be88/"+ @lat + ","+ @lng).read

    require 'json'

    parsed_data = JSON.parse(raw_data)

    @current_temperature = parsed_data["currently"]["temperature"]

    @current_summary = parsed_data["currently"]["summary"]

    @summary_of_next_sixty_minutes = parsed_data["minutely"]["summary"]

    @summary_of_next_several_hours = parsed_data["hourly"]["summary"]

    @summary_of_next_several_days = parsed_data["daily"]["summary"]

    render("street_to_weather.html.erb")
  end
end
