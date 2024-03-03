require_relative 'train'
require_relative 'passenger_train'
require_relative 'freight_train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'passenger_wagon'
require_relative 'freight_wagon'

def handle_user_command
  command = gets.chomp

  case command

  when 'create new station'
    create_new_station

  when 'show trains on station'
    show_trains_on_station

  when 'create new train'
    create_new_train

  when 'show train wagons'
    show_train_wagons

  when 'create new wagon'
    create_new_wagon

  when 'wagon menu'
    wagon_menu

  when 'route menu'
    route_menu

  when 'train set route'
    train_set_route

  when 'train add wagon'
    train_add_wagon

  when 'train remove wagon'
    train_remove_wagon

  when 'train move'
    train_move

  when 'show near stations'
    show_near_stations
  end
end

def create_new_station(station_name = nil)
  p 'Enter name of new station:'
  station_name ||= gets.chomp

  Station.add_station(Station.new(station_name))
  p Station.all
end

def show_trains_on_station
  train_str_num = 0

  p 'Enter station name:'
  station_name = gets.chomp

  Station.all[station_name].show_trains do |t|
    p "Train №#{train_str_num += 1}: name: #{t.name}, number: #{t.number}, type: #{t.type}, wagons: #{t.wagons}"
  end
end

def create_new_train
  p 'Enter name of new train:'
  train_name = gets.chomp

  p 'Enter number of new train:'
  train_number = gets.chomp

  p 'Enter train type:'
  train_type = gets.chomp

  begin
    case train_type
    when 'passenger'
      Train.add_train(PassengerTrain.new(train_name, train_number))
      p 'Passenger train was created'
      p Train.all

    when 'freight'
      Train.add_train(FreightTrain.new(train_name, train_number))
      p 'Freight train was created'
      p Train.all
    end
  rescue RuntimeError => e
    p "Error: #{e.message.downcase}, retry please"
    create_new_train
  end
end

def show_train_wagons
  wagon_str_num = 0

  p 'Enter train name:'
  train_name = gets.chomp

  if Train.all[train_name].type == 'passenger'
    Train.all[train_name].show_wagons do |w|
      p "Wagon №#{wagon_str_num += 1}: name: #{w.name}, number: #{w.number}, type: #{w.type}, places: #{w.places}"
    end
  elsif Train.all[train_name].type == 'freight'
    Train.all[train_name].show_wagons do |w|
      p "Wagon №#{wagon_str_num += 1}: name: #{w.name}, number: #{w.number}, type: #{w.type}, capacity: #{w.capacity}"
    end
  end
end

def create_new_wagon
  p 'Enter wagon name:'
  wagon_name = gets.chomp

  p 'Enter wagon number:'
  wagon_number = gets.to_i

  p 'Enter wagon type:'
  wagon_type = gets.chomp

  begin
    case wagon_type
    when 'passenger'
      p 'How much places?:'
      wagon_places = gets.to_i

      Wagon.add_wagon(PassengerWagon.new(wagon_name, wagon_number, wagon_places))
      p Wagon.all

    when 'freight'
      p 'How many capacity?:'
      wagon_capacity = gets.to_i

      Wagon.add_wagon(FreightWagon.new(wagon_name, wagon_number, wagon_capacity))
      p Wagon.all
    end
  rescue RuntimeError => e
    p "Error: #{e.message.downcase}, retry please"
    create_new_wagon
  end
end

def wagon_menu
  p 'Enter wagon type:'
  wagon_type = gets.chomp
  p 'Enter wagon name:'
  wagon_name = gets.chomp

  case wagon_type
  when 'passenger'
    p "Passenger wagon menu: 'show places', 'take place', 'show taked places', 'show free places'"
    p 'Enter your choice:'
    passenger_wagon_choice = gets.chomp

    case passenger_wagon_choice
    when 'show places'
      p Wagon.all[wagon_name].places

    when 'take place'
      p 'The place was taken'
      p Wagon.all[wagon_name].take_place

    when 'show taked places'
      p Wagon.all[wagon_name].taked_places

    when 'show free places'
      p Wagon.all[wagon_name].free_places
    end

  when 'freight'
    p "Freight wagon menu: 'show capacity', 'take capacity', 'show taked capacity', 'show free capacity'"
    p 'Enter your choice:'
    freight_wagon_choice = gets.chomp

    case freight_wagon_choice
    when 'show capacity'
      p Wagon.all[wagon_name].capacity

    when 'take capacity'
      p 'How much capacity do you want to take?:'
      capacity = gets.to_i
      p 'The capacity were taken'
      p Wagon.all[wagon_name].take_capacity(capacity)

    when 'show taked capacity'
      p Wagon.all[wagon_name].taked_capacity

    when 'show free capacity'
      p Wagon.all[wagon_name].free_capacity
    end
  end
end

def route_menu(route_choice: nil, route_name: nil, first_station_name: nil, last_station_name: nil, manage_option: nil, i: nil, station_name: nil)
  p "Enter 'new' to create new station"
  p "Enter 'manage' to manage"
  route_choice ||= gets.chomp

  case route_choice
  when 'new'
    p 'Enter name of new route:'
    route_name ||= gets.chomp
    p 'Enter name of first station:'
    first_station_name ||= gets.chomp
    p 'Enter name of last station:'
    last_station_name ||= gets.chomp

    first_station = Station.add_station(Station.new(first_station_name))

    last_station = Station.add_station(Station.new(last_station_name))

    Route.add_route(Route.new(route_name, first_station, last_station))
    p Route.all
  when 'manage'
    p "Enter 'add'/'remove' to manage"

    manage_option ||= gets.chomp

    case manage_option
    when 'add'
      p 'Enter route name that you want to change:'
      route_name ||= gets.chomp

      p 'Enter name of station that you want to add:'
      station_name ||= gets.chomp

      p 'Where do you want to add station?:'
      i ||= gets.to_i

      if Station.all.include?(station_name)
        Route.all[route_name].add_station(i, Station.all[station_name])
        p Route.all
      else
        p "There's no such station to add!"
      end
    when 'remove'
      p 'Enter name of route that you want to change:'
      route_name ||= gets.chomp

      p 'Enter name of station that you want to remove:'
      station_name ||= gets.chomp

      if Station.all.include?(station_name)
        Route.all[route_name].remove_station(Station.all[station_name])
      else
        p "There's no such sttation to remove!"
      end
    end
  end
end

def train_set_route
  p 'Enter train name for set route:'
  train_name = gets.chomp

  p 'Enter name of route:'
  route_name = gets.chomp

  if Route.all.include?(route_name)
    Train.all[train_name].set_route(Route.all[route_name])
    Train.all[train_name].current_station.trains << Train.all[train_name]
  else
    p "There's no such route to set!"
  end
end

def train_add_wagon
  p 'Enter train name:'
  train_name = gets.chomp

  p 'Enter name of wagon:'
  wagon_name = gets.chomp

  if Wagon.all.include?(wagon_name)
    Train.all[train_name].add_wagon(Wagon.all[wagon_name])
    p Train.all[train_name]
  else
    p "There's no such wagon to add!"
  end
end

def train_remove_wagon
  p 'Enter train name:'
  train_name = gets.chomp

  p 'Enter wagon name:'
  wagon_name = gets.chomp

  if Wagon.all.include?(wagon_name)
    Train.all[train_name].remove_wagon(Wagon.all[wagon_name])
    p Train.all[train_name]
  else
    p "There's no wagon to remove!"
  end
end

def train_move
  p 'Where do you want to move (forward/back)?'
  train_move = gets.chomp

  p 'Enter train name:'
  train_name = gets.chomp

  case train_move
  when 'forward'
    Train.all[train_name].send_to_next_station
  when 'back'
    Train.all[train_name].send_to_prev_station
  end
end

def show_near_stations
  p 'Enter train name:'
  train_name = gets.chomp

  Train.all[train_name].near_stations

  p 'Enter name of station:'
  station_name = gets.chomp

  p "Trains on station #{station_name}: #{Station.all[station_name].trains}"
end

loop do
  p 'Choose your destiny:'
  handle_user_command
  p "print 'exit' if you want to stop"
  break if gets.chomp == 'exit'
end