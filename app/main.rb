require 'sinatra'
require 'sinatra/reloader'

get "/" do
  @title = "main"
  erb :index
end
