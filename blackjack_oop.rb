# 1. Extract major nouns out of specifications

class Card
  attr_accessor :suit, :value

  def initialize(suit, value)
    @suit = suit
    @value = value
    suit = ['H', 'D', 'S', 'C']
    card = ['2', '3', '4', '5', '6', '7', '8', '10', 'J', 'Q', 'K', 'A']
  end

  def to_s
    "#{value} of #{suit}"
  end

end

class Deck 
  addr_accessor :cards
  def initialize
    @cards = []
    @deck = []
    @deck = suit.product(cards)
  end

  def shuffle
    @deck.shuffle!
  end

  def deal
    @cards << Card.new(arr[0], arr[1])
  end

end

class Hand 

end

class Player 

end

class Dealer 

end

class Blackjack
attr_accessor :deck, :player, :dealer, :hand

  def initialize
    @deck = Deck.new
    @player = Player.new("Bob")
  end

  def start
    deal_cards
    player_turn
    dealer_turn
    compare_who_won?
    play_again?
  end

  def deal_cards
    player.cards << deck.pop
  end

  def player_turn
    
  end

  def dealer_turn
  end

  def compare_who_won?
  end

  def play_again?
  end

end

game = Blackjack.new
game.start


card = Deck.new()

