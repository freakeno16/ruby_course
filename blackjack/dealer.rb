class Dealer
  attr_accessor :name, :hand, :bank, :sum

  def initialize
    @name = 'Dealer'
    @hand = Card.cards.sample(2); ace_val
    @bank = 100
    @sum = hand.first.value + hand.last.value
  end

  def take_card
    hand << c = Card.cards.sample(1)[0]
    @sum = sum + c.value
  end

  def place_bet
    @bank -= 10
  end

  def ace_val
    if hand.first.face == :A && hand.last.face == :A
      hand.first.value = 11
      hand.last.value = 1
    end
  end
end