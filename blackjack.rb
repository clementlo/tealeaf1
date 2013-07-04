arraydeck = [ 'ace' , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 10 , 10 , 10 , 
              'ace' , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 10 , 10 , 10 , 
              'ace' , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 10 , 10 , 10 , 
              'ace' , 2 , 3 , 4 , 5 , 6 , 7 , 8 , 9 , 10 , 10 , 10 , 10 ]
shuffled_deck = arraydeck.shuffle
player1_cards = []
dealer_cards = []

def calc_sum(card, current_sum)
  if card == 'ace'
    sum_with_1 = current_sum + 1
    sum_with_11 = current_sum + 11
    if sum_with_11 > 21
      sum = sum_with_1
    else
      sum = sum_with_11
    end
  else 
    sum = current_sum + card
  end
end

puts "Welcome to Blackjack"

puts "Please enter your name"
player1 = gets.chomp

player1_cards[0] = shuffled_deck.pop
puts player1 + "\'s first card is " + player1_cards[0].to_s
player1_cards[1] = shuffled_deck.pop
puts player1 + "\'s second card is " + player1_cards[1].to_s
player1_sum = player1_cards[0] + player1_cards[1]
puts player1 + "\'s total is " + player1_sum.to_s

dealer_cards[0]= shuffled_deck.pop
puts "The dealer\'s first card is " + dealer_cards[0].to_s

puts player1 + ", press H for hit or S for stay"
player1_status = gets.chomp

player_arrayindex = 1
dealer_arrayindex = 1
player1_sum = 0

while player1_status.downcase == 'h'
  player_arrayindex = player_arrayindex + 1
  player1_cards[player_arrayindex] = shuffled_deck.pop
  puts player1 + "\'s new card is " + player1_cards[player_arrayindex].to_s
  player1_sum = calc_sum (player1_cards[player_arrayindex], player1_sum)
  puts player1 + "\'s total is " + player1_sum.to_s

  if player1_sum > 21
    puts "You've busted! You Lose! GAME OVER!"
    break
  elsif player1_sum == 21
    puts "You Win!"
    break
  end

  puts player1 + ", press H for hit or S for stay"
  player1_status = gets.chomp  
end

if player1_status.downcase == 's'
  dealer_cards[1]= shuffled_deck.pop
  puts "The dealer\'s second card is " + dealer_cards[1].to_s
  dealer_sum = dealer_cards[0] + dealer_cards[1]
  puts "The dealer\'s total is " + dealer_sum.to_s
  
  while dealer_sum < 17
    dealer_arrayindex = dealer_arrayindex + 1
    dealer_cards[dealer_arrayindex]= shuffled_deck.pop
    puts "The dealer has dealt a" + dealer_cards[dealer_arrayindex]
    dealer_sum = dealer_sum + dealer_cards[dealer_arrayindex] 
    puts "The dealer\'s total is " + dealer_sum.to_s
    
    if dealer_sum > 21
      puts "The dealer has busted! You Win!"
      break
    end

  end

  if dealer_sum > player1_sum
    puts "You Lose!"
  elsif dealer_sum < player1_sum
    puts "You Win!"
  else
    puts "It's a Tie!"
  end

end




