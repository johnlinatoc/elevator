require 'rspec'
require_relative '../app/elevator.rb'
require_relative '../app/passenger.rb'

RSpec.configure do |config|
  config.before(:each) do
    allow($stdout).to receive(:puts)
    allow($stdout).to receive(:write)
  end
end

describe Elevator do
  subject { described_class.new }

  describe '#initialize' do
    context 'when creating elevator object' do
      it 'has number of floors set' do
        expect(subject).to have_attributes(total_floors: 10)
      end

      it 'has current floor set' do
        expect(subject).to have_attributes(current_floor: 1)
      end

      it 'has empty array set to contain all passenger destination requests' do
        expect(subject).to have_attributes(destinations: [])
      end

      it 'has direction of travel set to empty string when first starting' do
        expect(subject).to have_attributes(direction: '')
      end
    end
  end

  describe '#accept_passenger' do
    context 'when acceping a new, single passenger' do
      it 'instantiates new passenger object, then stores it in a hash with destination and stores it in @destinations' do
        allow_any_instance_of(Passenger).to receive(:gets).and_return('3')
        subject.accept_passenger
        expect(subject.destinations[0][:passenger]).to be_instance_of(Passenger)
        expect(subject.destinations[0][:floor]).to eq(3)
      end
    end
  end

  describe '#display_floor' do
    before(:each) { subject.current_floor = 3 }

    context 'when elevator is going up' do
      it 'should increment @current_floor' do
        subject.direction = 'up'
        subject.display_floor
        expect(subject.current_floor).to eq(4)
      end

      it 'should display current floor for 1 second' do
        subject.direction = 'up'
        expect { subject.display_floor }.to output(
          "Currently on floor #4.\n0 left onboard.\n\n"
        ).to_stdout

        allow_any_instance_of(Elevator).to receive(:sleep)
        expect(subject).to receive(:sleep).with(1)
        subject.display_floor
      end

      context 'when elevator is going down' do
        it 'should decrement @current_floor' do
          subject.direction = 'down'
          subject.display_floor

          expect(subject.current_floor).to eq(2)
        end

        it 'should display current floor for 1 second' do
          subject.direction = 'down'

          expect { subject.display_floor }.to output(
            "Currently on floor #2.\n0 left onboard.\n\n"
          ).to_stdout

          allow_any_instance_of(Elevator).to receive(:sleep)
          expect(subject).to receive(:sleep).with(1)
          subject.display_floor
        end
      end
    end
  end

  describe '#transport_all_passengers' do
    context 'when there is at least one passenger onboard' do
      before(:each) do
        srand(4)
        subject.destinations = [
          { passenger: Passenger.new(elevator: subject), floor: 3 },
          { passenger: Passenger.new(elevator: subject), floor: 4 }
        ]
        subject.current_floor = 2
      end
      it "should travel to that passenger's destination until all passengers reach their destinations" do
        allow_any_instance_of(Elevator).to receive(:gets).and_return('no')

        expect { subject.transport_all_passengers }.to output(
          "Going up!\n\nCurrently on floor #3.\n2 left onboard.\n\n\nYou have arrived on your floor!!!\n\n\nThanks for riding! 2 left on board. Would you like to stay on and watch the elevator run?\nThank you for riding this elevator! Have a great day!\nServing next passenger!\n"
        ).to_stdout
      end
    end

    context 'when there are no passengers left onboard' do
      it 'should call #handle_empty_elevator' do
        allow_any_instance_of(Elevator).to receive(:gets).and_return('no')
        subject.destinations = []

        expect(subject).to receive(:handle_empty_elevator)
        subject.transport_all_passengers
      end
    end
  end

  describe '#handle_empty_elevator' do
    context 'when there are no more passengers on board and user wants to ride again' do
      it 'should call #accept_passenger and #transport_all_passengers' do
        allow_any_instance_of(Elevator).to receive(:gets).and_return('y')
        expect(subject).to receive(:accept_passenger)
        expect(subject).to receive(:transport_all_passengers)
        subject.handle_empty_elevator
      end
    end

    context 'when there are no more passengers on board and user doesnt want to ride again' do
      it 'should quit program with correct message' do
        allow_any_instance_of(Elevator).to receive(:gets).and_return('n')
        expect { subject.handle_empty_elevator }.to output(
          "\nNo more passengers left onboard. Would you like to choose another floor and ride again?\n\nThank you for riding this elevator! Have a great day!\n\nElevator going on standby...\n\n"
        ).to_stdout
      end
    end
  end

  describe 'handle_one_direction' do
    context 'when serving first passenger onboard' do
      before :each do
        srand(4)
      end

      it 'should be going only one direction till destination reached' do
        passenger1 = Passenger.new(elevator: subject)
        passenger1.desired_floor = 3
        subject.destinations = [
          { passenger: passenger1, floor: 3, direction: 'up' },
          {
            passenger: Passenger.new(elevator: subject),
            floor: 4,
            direction: 'down'
          },
          {
            passenger: Passenger.new(elevator: subject),
            floor: 5,
            direction: 'down'
          }
        ]
        subject.current_floor = 1
        subject.handle_one_direction

        expect(subject.destinations.length).to eq(2)
      end
    end
  end

  describe '#handle_first_passenger_finished' do
    context 'when initial user has reached their destination and others still onboard' do
      it 'should call handle_watch_elevator if choosing to stay on' do
        subject.destinations = [
          {
            passenger: Passenger.new(elevator: subject),
            floor: 4,
            direction: 'down'
          },
          {
            passenger: Passenger.new(elevator: subject),
            floor: 5,
            direction: 'down'
          }
        ]
        allow_any_instance_of(Elevator).to receive(:gets).and_return('y')
        expect(subject).to receive(:handle_watch_elevator)
        subject.handle_first_passenger_finished
      end

      it 'should exit program if not choosing to stay on' do
        subject.destinations = [
          {
            passenger: Passenger.new(elevator: subject),
            floor: 5,
            direction: 'down'
          }
        ]
        allow_any_instance_of(Elevator).to receive(:gets).and_return('n')
        expect { subject.handle_empty_elevator }.to output(
          "\nNo more passengers left onboard. Would you like to choose another floor and ride again?\n\nThank you for riding this elevator! Have a great day!\n\nElevator going on standby...\n\n"
        ).to_stdout
      end
    end

    context 'when initial destination reached, but there are none onboard' do
      it 'should call #handle_empty_elevator' do
        subject.destinations = []
        expect(subject).to receive(:handle_empty_elevator)
        subject.handle_first_passenger_finished
      end
    end
  end

  describe '#action_per_floor' do
    context 'when there are passengers present on the elevator' do
      before(:each) do
        srand(4)
        passenger1 = Passenger.new(elevator: subject)
        passenger1.desired_floor = 3
        subject.destinations = [
          { passenger: passenger1, floor: 3, direction: 'up' },
          {
            passenger: Passenger.new(elevator: subject),
            floor: 4,
            direction: 'up'
          },
          {
            passenger: Passenger.new(elevator: subject),
            floor: 5,
            direction: 'up'
          }
        ]
      end
      it 'drops off any passengers if current floor is equal to any of passengers onboard destinations' do
        subject.current_floor = 3
        subject.action_per_floor

        expect(subject.destinations.length).to eq(2)
      end
    end
  end

  describe '#randomly_onboard' do
    context 'when there are 2 new passengers onboarding' do
      before :each do
        srand(2)
        subject.direction = 'up'
      end

      it 'accepts them and adds them into total passengers' do
        subject.randomly_onboard

        expect(subject.destinations.length).to eq(2)
      end
    end
  end
end
