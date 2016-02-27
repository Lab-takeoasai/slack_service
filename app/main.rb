require 'sinatra'
require 'sinatra/reloader'

require_relative "./hatenabookmark.rb"

get "/" do
  @title = "main"


  erb :index
end
