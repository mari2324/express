require 'bundler/setup'
Bundler.require
require 'sinatra/reloader' if development?
require 'open-uri'
require 'json'
require 'sinatra/json'
require 'net/http'
require 'sinatra/activerecord'
require './models'

get '/' do
    @histories=History.all
    @favorites=History.where(favorite: true)
    erb :form
end

get '/list' do
    uri=URI("http://express.heartrails.com/api/json")
    uri.query=URI.encode_www_form({method:"getStations",x:params[:x],y:params[:y]})
    res=Net::HTTP.get_response(uri)
    json=JSON.parse(res.body)
    p json
    @stations=json["response"]["station"]
    History.create!(x: params[:x],y: params[:y])
    erb :list
end

get '/api/station' do
    uri=URI("http://express.heartrails.com/api/json")
    uri.query=URI.encode_www_form({method:"getStations", line:params[:line], name:params[:name]})
    res=Net::HTTP.get_response(uri)
    json=JSON.parse(res.body)
    p params[:line], params[:name]
    p json
    if json["response"]["error"]
        @res= {error: "No Station"}
    else
        @res= {
            next: json["response"]["station"][0]["next"],
            prev: json["response"]["station"][0]["prev"],
            distance:json["response"]["station"[0]]["distance"]
        }

    end
    p @response
    json @res
end  

post '/:id/delete' do
    history=History.find(params[:id])
    history.delete
    redirect "/"
end

post '/:id/update' do
    history=History.find(params[:id])
    history.favorite=!history.favorite
    history.comment=params[:comment]
    history.save
    redirect "/"
end