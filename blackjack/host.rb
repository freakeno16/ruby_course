class Host
  def self.open_cards(p, d)
    puts 'Opening the players cards....'
    sleep(1)

    puts "Here's #{d.name}'s cards:"
    d.hand.each { |c| puts "|#{c.face}" + "#{c.suit}|" }
    puts "Total: #{d.sum}"
    sleep(1)

    puts "Here's #{p.name}'s cards:"
    p.hand.each { |c| puts "|#{c.face}" + "#{c.suit}|" }
    puts "Total: #{p.sum}"

    p_rate = 21 - p.sum
    d_rate = 21 - d.sum

    p_rate *= -1 if p_rate.negative?
    d_rate *= -1 if d_rate.negative?

    if p.sum <= 21 && d.sum > 21
      puts "------------------------------------------------\n#{p.name} wins, #{d.name} has to many points!"
      p.bank += d.bank
      d.bank = 0
    elsif d.sum <= 21 && p.sum > 21
      puts "------------------------------------------------\n#{d.name} wins, #{p.name} has to many points!"
      d.bank += p.bank
      p.bank = 0
    elsif p_rate < d_rate
      puts "------------------------------------------------\n#{p.name} wins!"
      p.bank += d.bank
      d.bank = 0
    elsif d_rate < p_rate
      puts "------------------------------------------------\n#{d.name} wins!"
      d.bank += p.bank
      p.bank = 0
    end

    if p.sum == d.sum
      puts "------------------------------------------------\nDraw!"
      d.bank = 100
      p.bank = 100
    end

    puts "#{p.name} bank: #{p.bank}$"
    puts "#{d.name} bank: #{d.bank}$\n------------------------------------------------"
  end

  def self.player_choice(p, d)
    choice = gets.chomp.capitalize!
    case choice
    when 'Pass'
      Host.dealer_choice(d, p)
    when 'Take'
      p.take_card

      puts "#{p.name} takes card"
      puts "Here's #{p.name}'s cards:"
      p.hand.each { |c| puts "|#{c.face}" + "#{c.suit}|" }
      puts "Total: #{p.sum}"

      if p.hand.length == 3 && d.hand.length == 3
        Host.open_cards(p, d)
      else
        Host.dealer_choice(d, p)
      end
    when 'Open'
      Host.open_cards(p, d)
    end
  end

  def self.dealer_choice(d, p)
    if d.sum < 17 && d.hand.length < 3
      d.take_card

      puts "#{d.name} takes card"
      puts "Dealer's cards are hidden:"
      puts '*'
      puts '*'
      puts '*'
      puts 'Total: **'

      Host.open_cards(p, d) if p.hand.length == 3 && d.hand.length == 3
    else
      puts "#{d.name} skips his turn"
    end
    Host.player_choice(p, d)
  end
end
