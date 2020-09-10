class Passenger
  attr_reader :elevator
  attr_accessor :desired_floor

  def initialize(elevator:)
    @elevator = elevator
    @desired_floor = ''
  end

  def input_desired_floor
    puts ''
    puts "Currently on floor ##{
           @elevator.current_floor
         }. What floor would you like to go to? Choose between floors #{
           @elevator.current_floor == 1 ? 2 : 1
         } and #{@elevator.total_floors}."
    floor = gets.chomp.to_s
    puts ''
    if floor.match(/^[0-9]*$/) &&
         floor.to_i.between?(1, @elevator.total_floors) &&
         floor.to_i != @elevator.current_floor
      puts 'Got it, thanks!'
      puts ''
      sleep(1)
      @desired_floor = floor
    else
      puts 'Sorry, please choose a valid floor number. '
      input_desired_floor
    end
  end

  def display_message
    puts ''
    puts 'You have arrived on your floor!!!'
    puts ''
    sleep(1)
  end
end
