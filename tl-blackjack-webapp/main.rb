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

  def card_image(card)
    suit = case card[0]
      when 'H' then 'hearts'
      when 'D' then 'diamonds'
      when 'C' then 'clubs'
      when 'S' then 'spades'
    end

    value = card[1]
    if ['J','Q', 'K', 'A'].include?(value)
      value = case card[1]
        when 'J' then 'jack'
        when 'Q' then 'queen'
        when 'K' then 'king'
        when 'A' then 'ace'
      end
    end
    "<img src= '/images/cards/#{suit}_#{value}.jpg' class='card_image'>"
  end
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
  if params[:player_name].empty?
    @error = "Name is required"
    halt erb(:new_player)
  end

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
    @success = "Congratulations, #{session[:player_name]} hit blackjack!"
    @show_buttons = false
  end
  erb :game
end

#player turn - hit or stay
post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
    player_total = calculate_total(session[:player_cards])
    if player_total > 21
      @error = "Sorry, it looks like #{session[:player_name]} busted"
      @show_buttons = false
    elsif player_total == 21
    @success = "Congratulations, #{session[:player_name]} hit blackjack!"
    @show_buttons = false
    end
  erb :game
end

post '/game/player/stay' do
  @success = "#{session[:player_name]} has chosen to stay."
  @show_buttons = false
  # dealer_total = calculate_total(session[:dealer_cards])
  # player_total = calculate_total(session[:player_cards])
  if calculate_total(session[:dealer_cards]) == 21 
    @error = "Sorry, the dealer hit blackjack. #{session[:player_name]} loses!"
  end
  while calculate_total(session[:dealer_cards]) < 17
    session[:dealer_cards] << session[:deck].pop
    if calculate_total(session[:dealer_cards]) == 21 
      @error = "Sorry, the dealer hit blackjack. #{session[:player_name]} loses!"
    elsif calculate_total(session[:dealer_cards]) > 21 
      @success = "The dealer has busted! #{session[:player_name]} wins!"
    end
  end
  if calculate_total(session[:dealer_cards]) < 21
    if calculate_total(session[:dealer_cards]) > calculate_total(session[:player_cards])
      @error = "Sorry, the dealer wins!"
    elsif calculate_total(session[:dealer_cards]) < calculate_total(session[:player_cards])
      @success = "#{session[:player_name]} wins!"
    else
      @success = "It's a tie!"
    end
  end
  erb :game
end
