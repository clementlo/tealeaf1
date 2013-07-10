
def calculate_total(cards) 
#[['H' , '3'], ['S', 'Q'], ...]
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

# Start Game

puts "Welcome to Blackjack"

suits = ['H', 'D', 'S', 'C']
cards = ['2', '3', '4', '5', '6', '7', '8', '10', 'J', 'Q', 'K', 'A']

#Create the product of two arrays to get all combinations as a new arrays

#deck = []
#suits.each do |suit|
#    cards.each do |card|
#      deck << [suit, card]
#    end
#end

#Deal Cards

deck = suits.product(cards)
deck.shuffle!

# Deal cards

mycards = []
dealercards = []

mycards << deck.pop
dealercards << deck.pop
mycards << deck.pop
dealercards << deck.pop

dealertotal = calculate_total(dealercards)
mytotal = calculate_total(mycards)

# Show cards

puts "Dealer has: #{dealercards[0]} and #{dealercards[1]}, for a total of #{dealertotal}"
puts "You have: #{mycards[0]} and #{mycards[1]}, for a total of #{mytotal}"
puts ""

#Player Turn
if mytotal == 21
  puts "Congratulations, you hit blackjack! You win!"
  exit
end

while mytotal < 21
  puts "What would you like to do? 1) hit 2) stay"
  hit_or_stay = gets.chomp

  if !['1', '2'].include?(hit_or_stay)
    puts "Error: you must enter 1 or 2"
    next
  end
  if hit_or_stay == "2"
    puts "You chose to stay."
    break
  end

  #hit
  new_card = deck.pop
  puts "Dealing card to player: #{new_card}"
  mycards << new_card
  mytotal = calculate_total(mycards)
  puts "Your total is now: #{mytotal}" 

  if mytotal == 21
    puts "Congratulations, you hit blackjack! You win!"
    exit
  elsif mytotal > 21
    puts "Sorry, you busted!"
    exit
  end
end

# Dealer turn

if dealertotal == 21
  puts "Sorry, dealer hit blackjack. You lose."
  exit
end

while dealertotal < 17
  #hit
  new_card = deck.pop
  puts "Dealing new card for dealer: #{new_card}"
  dealercards << new_card
  dealertotal = calculate_total(dealercards)
  puts "Dealer total is now: #{dealertotal}"

  if dealertotal == 21
    puts "Sorry, dealer hit blackjack. You lose."
  elsif dealertotal > 21
    puts "Congratulations, dealer busted! You win!"
  end  
end

# Compare hands

puts "Dealer's cards: "
dealercards.each do |card|
  puts "=> #{card}"
end

puts "Your cards: "
mycards.each do |card|
  puts "=>  #{card}"
end
puts ""

if dealertotal > mytotal
  puts "Sorry, dealer won."
elsif dealertotal < mytotal
  puts "Congratulations, you won"
else
  puts "It's a tie" 
end