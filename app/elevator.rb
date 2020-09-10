require_relative 'passenger'
require 'pry'

class Elevator
  attr_reader :total_floors
  attr_accessor :destinations, :current_floor, :direction

  def initialize
    @current_floor = 1
    @destinations = []
    @direction = ''
    @total_floors = 10
  end

  def accept_passenger
    passenger = Passenger.new(elevator: self)
    desired_floor = passenger.input_desired_floor.to_i
    desired_floor > @current_floor ? direction = 'up' : direction = 'down'
    trip = { passenger: passenger, floor: desired_floor, direction: direction }
    @destinations.push(trip)
  end

  def display_floor
    if @direction == 'up'
      @current_floor += 1
    elsif @direction == 'down'
      @current_floor -= 1
    end
    sleep(1)
    puts "Currently on floor ##{@current_floor}."
    puts "#{@destinations.length} left onboard."
    puts ''
  end

  def transport_all_passengers
    if @destinations.length != 0
      handle_one_direction
      handle_first_passenger_finished
    else
      handle_empty_elevator
    end
  end

  def handle_empty_elevator
    puts ''
    puts 'No more passengers left onboard. Would you like to choose another floor and ride again?'
    reply = gets.chomp
    puts ''
    if reply.downcase.include?('y')
      accept_passenger
      transport_all_passengers
    elsif reply.downcase.include?('n')
      puts 'Thank you for riding this elevator! Have a great day!'
      sleep(1)
      puts ''
      puts 'Elevator going on standby...'
      puts ''
      sleep(1)
    else
      puts 'Please input yes or no'
      handle_empty_elevator
    end
  end

  def handle_one_direction
    main_passenger = @destinations.first
    floors_till_destination = ((main_passenger[:floor]) - @current_floor).abs
    if main_passenger[:floor] > @current_floor
      @direction = 'up'
    else
      @direction = 'down'
    end
    puts "Going #{@direction}!"
    puts ''
    floors_till_destination.times { action_per_floor }

    main_passenger[:passenger].display_message
  end

  def handle_first_passenger_finished
    if @destinations.length > 0
      puts ''
      puts "Thanks for riding! #{
             @destinations.length
           } left on board. Would you like to stay on and watch the elevator run?"
      sleep(1)
      reply = gets.chomp
      if reply.downcase.include?('y')
        puts ''
        puts 'Okay!'
        puts ''
        sleep(1)
        handle_watch_elevator
      elsif reply.downcase.include?('n')
        puts 'Thank you for riding this elevator! Have a great day!'
        sleep(1)
        puts 'Serving next passenger!'
        sleep(1)
      end
    else
      handle_empty_elevator
    end
  end

  def handle_watch_elevator
    if @destinations.length == 0
      handle_empty_elevator
      abort
    end
    main_passenger = @destinations.first
    floors_till_destination = (main_passenger[:floor] - @current_floor).abs
    if main_passenger[:floor] > @current_floor
      @direction = 'up'
    else
      @direction = 'down'
    end

    action_per_floor if @destinations.length > 0

    handle_watch_elevator
  end

  def action_per_floor
    display_floor
    offboarding_passengers = 0
    @destinations.each do |trip|
      if trip[:passenger].desired_floor.to_i == @current_floor.to_i
        offboarding_passengers += 1
        @destinations.delete(trip)
      end
    end
    randomly_onboard
  end

  def randomly_onboard
    # 33% chance of someone getting on
    new_passenger_chance = rand(1..3)
    if new_passenger_chance == 1
      #1, 2 or 3 people will get on randomly
      new_passengers = []
      num_of_passengers = rand(1..3)

      num_of_passengers.times do
        new_passenger = Passenger.new(elevator: self)
        desired_floor = rand(1..@total_floors)
        new_passenger.desired_floor = desired_floor
        direction = desired_floor > @current_floor ? 'up' : 'down'

        if (new_passenger.desired_floor != @current_floor) &&
             (direction == @direction)
          new_passengers.push(
            {
              passenger: new_passenger,
              floor: desired_floor,
              direction: direction
            }
          )
        end
      end

      new_passengers.each { |passenger| @destinations.push(passenger) }

      if new_passengers.length != 0
        puts "#{new_passengers.length} boarded this elevator."
        puts ''
      end
    end
  end

  def welcome_message
    puts '=============================='
    puts '=============================='
    puts '== Welcome To The Elevator! =='
    puts '=============================='
    puts '=============================='
    puts ''
    sleep (1)
    accept_passenger
    transport_all_passengers
  end
end
