require 'rubygems'
require 'sinatra'

set :sessions, true

BLACKJACK_AMOUNT = 21
DEALER_MIN_HIT = 17
INITIAL_BALANCE = 500

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
      if total > BLACKJACK_AMOUNT
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

  def winner!(msg)
    @show_buttons = false
    @show_play_again = true
    session[:player_pot] += session[:player_bet]
    @success = "<strong>#{session[:player_name]} wins! </strong> #{msg} Your new balance is #{session[:player_pot]}."
  end  

  def loser!(msg)
    @show_buttons = false
    @show_play_again = true
    session[:player_pot] -= session[:player_bet]
    @error = "<strong>#{session[:player_name]} loses!</strong> #{msg} Your new balance is $#{session[:player_pot]}."
  end

  def tie!(msg)
    @success = "<strong>It's a tie!</strong> #{msg} Your remains at $#{@balance}."
    @show_buttons = false
    @show_play_again = true
  end

end

before do 
  @show_buttons = true
  @show_dealer_hit_button = false
  @hide_first_card = true
  @show_play_again = false
end

get '/' do
  if session[:player_name]
    redirect '/game'
  else
  redirect '/new_player'
  end
end

get '/new_player' do
  session[:player_pot] = INITIAL_BALANCE
  erb :new_player
end

post '/new_player' do
  if params[:player_name].empty?
    @error = "Name is required"
    halt erb(:new_player)
  end
  session[:player_name] = params[:player_name]
  redirect '/bet'
end

get '/bet' do
  session[:player_bet] = nil
  erb :bet
end

post '/bet' do
  if params[:player_bet].nil? || params[:player_bet].to_i <= 0
    @error = "Bet amount must be greater than 0"
    halt erb(:bet)
  elsif params[:player_bet].to_i > session[:player_pot].to_i
    @error = "Bet amount must not be greater than $#{session[:player_pot]}"
    halt erb(:bet)
  else #accept bet 
    session[:player_bet] = params[:player_bet].to_i
    redirect '/game'
  end
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
    winner!("Congratulations, #{session[:player_name]} hit blackjack!")
    @show_buttons = false
  end
  erb :game
end

#player turn - hit or stay
post '/game/player/hit' do
  session[:player_cards] << session[:deck].pop
    player_total = calculate_total(session[:player_cards])
    if player_total > BLACKJACK_AMOUNT
      loser!("#{session[:player_name]} busted at #{player_total}.")
    elsif player_total == BLACKJACK_AMOUNT
      winner!("Congratulations, #{session[:player_name]} hit blackjack!")
    end
  erb :game
end

post '/game/player/stay' do
  @success = "#{session[:player_name]} has chosen to stay."
  redirect '/game/dealer'
end

get '/game/dealer' do
  @show_buttons = false
  @hide_first_card = false
  dealer_total = calculate_total(session[:dealer_cards])
  if dealer_total == BLACKJACK_AMOUNT
    loser!("Sorry, the dealer hit blackjack.")
  elsif dealer_total > BLACKJACK_AMOUNT
    winner!("The dealer has busted at #{dealer_total}.")
  elsif dealer_total < DEALER_MIN_HIT
    @show_dealer_hit_button = true
  else # >=17
    redirect '/game/compare'
  end
erb :game 
end

post '/game/dealer/hit' do
  @hide_first_card = false
  @show_buttons = false
  session[:dealer_cards] << session[:deck].pop
  redirect '/game/dealer'
end

get '/game/compare' do
  @hide_first_card = false
  @show_buttons = false
  player_total = calculate_total(session[:player_cards])
  dealer_total = calculate_total(session[:dealer_cards])
  if dealer_total > player_total
    loser!("#{session[:planer_name]} stayed at #{player_total}, and the dealer stayed at #{dealer_total}.")
  elsif dealer_total < player_total
    winner!("#{session[:planer_name]} stayed at #{player_total}, and the dealer stayed at #{dealer_total}.")
  else
    tie!("#{session[:player_name]} stayed at #{player_total}.")
  end
erb :game  
end

get '/game_over' do
  erb :gameover
end
