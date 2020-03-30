require 'rest-client'

class Weather
  API_URL = 'api.openweathermap.org/data/2.5/'.freeze
  APPID = 'YOUR_TOKEN'.freeze

  def initialize(city)
    @city = city
  end

  attr_reader :city

  def form_message
    temperature.nil? ? 'City not found' : "In #{city} city today is #{temperature} celsius #{select_icon(temperature)}"
  end

  private

  def weather_url
    "#{API_URL}/weather?q=#{city}&APPID=#{APPID}&units=metric"
  end

  def weather_response
    @response_body ||= RestClient.get(weather_url).body
    JSON(@response_body)
  end

  def temperature
    weather = weather_response
    return nil unless weather

    weather.dig('main', 'temp').to_i
  end

  def weather_icons
    {
      40..49 => '🔥',
      30..39 => '☀️',
      20..29 => '🌤',
      10..19 => '⛅️',
      0 => '☁️',
      -10..-1 => '☃️',
      -20..-11 => '❄️'
    }
  end

  def select_icon(temperature)
    icon = weather_icons.select { |ico| ico === temperature }.values.first
    icon = '✨' if icon.nil?
    icon
  end
end
