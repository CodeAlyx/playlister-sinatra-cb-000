require 'rack-flash'

class SongController < ApplicationController
  enable :sessions
  use Rack::Flash

  get '/songs' do
    @songs = Song.all
    erb :'songs/index'
  end

  get '/songs/new' do
    erb :'songs/new'
  end

  get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/edit'
  end

  post '/songs' do
    song = Song.create(params[:song])
    song.artist = Artist.find_or_create_by(name: params[:artist][:name])
    song.save
    flash[:message] = "Successfully created song."
    redirect "/songs/#{song.slug}"
  end

  patch '/songs/:slug' do
    song = Song.find_by_slug(params[:slug])
    song.update(params[:song])
    song.artist = Artist.find_or_create_by(name: params[:artist][:name])
    song.save
    redirect "/songs/#{song.slug}"
  end
end
