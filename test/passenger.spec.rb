require 'rspec'
require_relative '../app/passenger.rb'
require_relative '../app/elevator.rb'

describe Passenger do
  elevatorExample = Elevator.new
  subject { described_class.new(elevator: elevatorExample) }

  describe '#initialize' do
    context 'when creating a new passenger' do
      it 'should accept an instance of Elevator' do
        expect(subject.elevator).to be_kind_of(Elevator)
      end
    end
  end

  describe '#input_desired_floor' do
    context 'when given a desired floor number' do
      it 'should save the floor number in instance variable @desired_floor' do
        allow_any_instance_of(Passenger).to receive(:gets).and_return('6')
        subject.input_desired_floor

        expect(subject).to have_attributes(desired_floor: '6')
      end

      it 'should be a number' do
        allow_any_instance_of(Passenger).to receive(:gets).and_return('abc')
        expect(subject).to receive(:input_desired_floor)
        subject.input_desired_floor
      end
    end
  end

  describe '#display_message' do
    context 'when passenger arrives at desired floor' do
      it 'should display message that desired floor has been reached' do
        expect { subject.display_message }.to output(
          "\nYou have arrived on your floor!!!\n\n"
        ).to_stdout
      end
    end
  end
end
