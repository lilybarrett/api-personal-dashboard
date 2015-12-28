require "./lib/geolocation"
require "./lib/weather"
require "sinatra/base"
require "json"
require "net/http"
require "pry"

require "dotenv"
Dotenv.load

def get_location
  @ip = request.ip
  @geolocation = Geolocation.new(@ip)
  @city = @geolocation.city
  @state = @geolocation.state
end

def get_weather
  get_location
  w_key = ENV["WUNDERGROUND_API_KEY"]
  url = "http://api.wunderground.com/api/#{w_key}/conditions/q/"
  url += "#{@state}"
  url += "/#{@city}.json"
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  @temp_f = JSON.parse(response.body)["current_observation"]["temp_f"]
end

def get_news
  nytkey = ENV["NYTIMES_API_KEY"]
  uri = URI("http://api.nytimes.com/svc/topstories/v1/technology.json?api-key=#{nytkey}")
  response = Net::HTTP.get_response(uri)
  @stories = JSON.parse(response.body)["results"]
end

def get_events
  get_location
  city = @city
  state = @state
  today = Time.now.strftime("%Y-%m-%d")

  url = "http://api.seatgeek.com/2/events"
  url += "?venue.city=#{city}"
  url += "&datetime_local.gte=#{today}"

  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  @events = JSON.parse(response.body)["events"]
end

class Dashboard < Sinatra::Base
  get("/") do
    get_location
    erb :dashboard
  end

  get "/weather" do
    get_weather
    erb :weather
  end

  get "/events" do
    get_events
    erb :events
  end

  get "/news" do
    get_news
    erb :news
  end
end
