require_relative 'player'
require_relative 'dealer'
require_relative 'card'
require_relative 'host'

loop do
  Card.generate_cards

  puts 'Enter your name:'
  player_name = gets.chomp.capitalize!

  p = Player.new(player_name)
  d = Dealer.new

  puts "#{p.name} join the game!"
  puts "#{p.name} remember, you can only [Take/Pass/Open]"
  sleep(1)

  puts "Here's #{p.name}'s cards:"
  p.hand.each { |c| puts "|#{c.face}" + "#{c.suit}|" }
  puts "Total: #{p.sum}"
  
  puts "Dealer's cards are hidden:"
  puts '*'
  puts '*'
  puts 'Total: **'

  puts 'The player and the dealer have placed a bet'

  p.place_bet
  d.place_bet
  puts "Player bank: #{p.bank}$"
  puts "Dealer bank: #{d.bank}$"

  Host.player_choice(p, d)

  puts "Wanna retry? [enter/no]"
  answer = gets.chomp.capitalize!
  break if answer == 'No'
end
