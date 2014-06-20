
require './browser'

class BrowserActions < Sinatra::Application

  my_browser = Browser.new

  get '/start' do
    name = params[:name]
    version = params[:version]
    url = params[:url]
    proxy = params[:proxy]
    port = params[:port]
    my_browser.start(name, version, url, proxy, port)
  end

  get '/stop' do
    name = params[:name]
    version = params[:version]
    my_browser.stop(name, version)
  end

  get '/clean' do
    name = params[:name]
    version = params[:version]
    my_browser.clean(name, version)
  end


end