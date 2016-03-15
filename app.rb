class DalliBench < Sinatra::Base
  configure do
    disable :static
    disable :protection
  end

  get '/' do
    session[:name] ||= params[:name] || 'world'.freeze
    "Hello, #{session[:name]}!\n"
  end
end
