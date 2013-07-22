require 'rubygems'
require 'sinatra'

set :sessions, true

# get '/inline' do 
#   "Hi, directly from the action!"
# end
# 
# get '/template' do
#   erb :mytemplate
# end
# 
# get '/nested_template' do
#   erb :"/users/profile"
# end
# 
# get '/nothere' do
#   redirect '/inline'
# end
# 
# get '/form' do
#   erb :form
# end
# 
# post '/myaction' do
#   puts params['username']
# end


get '/' do
  if session[:player_name]
    redirect '/game'
  else
  redirect '/new_player'
  end
end

get '/new_player' do
  erb :new_player
end

post '/new_player' do
  session[:player_name] = params[:player_name]
  redirect '/game'
end


get '/game' do
  # set up initial game values
  # Create a deck and put it into the session.
  suits = ['H', 'D', 'S', 'C']
  cards = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
  session[:deck] = suits.product(cards).shuffle!

  # deal cards

  session[:player_cards] = []
  session[:dealer_cards] = []
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  session[:dealer_cards] << session[:deck].pop
  session[:player_cards] << session[:deck].pop
  
  #session[:dealer_total] = calculate_total(session[:dealer_cards])
  #session[:player_total] = calculate_total(session[:player_cards])
  



  erb :game
end