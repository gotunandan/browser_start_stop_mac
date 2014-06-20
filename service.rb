require 'rubygems'
require 'sinatra'

require './browseractions'

BrowserActions.run!({
  :bind => '0.0.0.0',
  :port => 4567,
})