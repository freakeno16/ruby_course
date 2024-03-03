class Player
  attr_accessor :name, :hand, :bank, :sum

  def initialize(name)
    @name = name
    @hand = Card.cards.sample(2); ace_val
    @bank = 100
    @sum = hand.first.value + hand.last.value
  end

  def take_card
    if hand.length == 2
      hand << c = Card.cards.sample(1)[0]
      if c.face == :A
        if c.value + sum > 21
          c.value = 1
        else c.value = 11
        end
      end
      @sum = sum + c.value
    else
      puts 'You can only take one card!'
    end
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