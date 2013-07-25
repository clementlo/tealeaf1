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

helpers do
  def calculate_total(cards) # cards
    arr = cards.map {|e| e[1] }

    total = 0
    arr.each do |value|
      if value == "A"
        total += 11 
      elsif value.to_i == 0 #J, Q, K
        total += 10
      else
        total += value.to_i
      end
    end

    #correct for Aces
    arr.select{|e| e == 'A'}.count.times do
      if total > 21
        total -= 10
      end
    end
    total
  end
    # calculate_total(session[:dealer_cards])
end

before do 
  @show_buttons = true
end

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

 if calculate_total(session[:player_cards]) == 21
    @success = "Congratulations, you hit blackjack!"
    @show_buttons = false
  end
  erb :game
end

#player turn - hit or stay
post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
    if calculate_total(session[:player_cards]) > 21
      @error = "Sorry, it looks like you busted"
      @show_buttons = false
    elsif calculate_total(session[:player_cards]) == 21
    @success = "Congratulations, you hit blackjack!"
    @show_buttons = false
    end
  erb :game
end

post '/game/player/stay' do
  @success = "You have chosen to stay."
  @show_buttons = false
  if calculate_total(session[:dealer_cards]) == 21 
    @error = "Sorry, the dealer hit blackjack. You lose!"
  end
  while calculate_total(session[:dealer_cards]) < 17
    session[:dealer_cards] << session[:deck].pop
    if calculate_total(session[:dealer_cards]) == 21 
      @error = "Sorry, the dealer hit blackjack. You lose!"
    elsif calculate_total(session[:dealer_cards]) > 21 
      @success = "The dealer has busted! You Win!"
    end
  end
  if calculate_total(session[:dealer_cards]) < 21
    if calculate_total(session[:dealer_cards]) > calculate_total(session[:player_cards]) 
      @error = "Sorry, the dealer wins!"
    elsif calculate_total(session[:dealer_cards]) < calculate_total(session[:player_cards]) 
      @success = "You win!"
    else
      @success = "It's a tie!"
    end
  end
  erb :game
end
