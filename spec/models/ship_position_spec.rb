require 'rails_helper'

RSpec.describe ShipPosition, type: :model do

  it 'should have valid factory' do
    expect(FactoryGirl.build(:ship_position)).to be_valid
  end

  context 'course' do
    it 'should reject a negative course' do
      expect(FactoryGirl.build(:ship_position, course: -1)).not_to be_valid
    end

    it 'should reject values bigger then 360' do
      expect(FactoryGirl.build(:ship_position, course: 361)).not_to be_valid
    end

    it 'should validate 180 just fine' do
      expect(FactoryGirl.build(:ship_position, course: 180)).to be_valid
    end
  end

  context 'speed' do
    it 'should reject a negative speed' do
      expect(FactoryGirl.build(:ship_position, speed: -1)).not_to be_valid
    end

    it 'should reject a speed above 100' do
      expect(FactoryGirl.build(:ship_position, speed: 101)).not_to be_valid
    end

    it 'validates a usual speed' do
      expect(FactoryGirl.build(:ship_position, speed: 22.3)).to be_valid
    end
  end

  context 'status' do
    it 'should reject a negative status' do
      expect(FactoryGirl.build(:ship_position, status: -1)).not_to be_valid
    end

    it 'should reject a status over 15' do
      expect(FactoryGirl.build(:ship_position, status: 16)).not_to be_valid
    end

    it 'validates a status of 0' do
      expect(FactoryGirl.build(:ship_position, status: 0)).to be_valid
    end
  end

  context 'timestamp' do
    it 'requires a timestamp' do
      expect(FactoryGirl.build(:ship_position, timestamp: nil)).not_to be_valid
    end

    it 'rejects invalid dates' do
      expect(FactoryGirl.build(:ship_position, timestamp: "2012-13-32T21:15:00")).not_to be_valid
    end

    it 'validates dates' do
      expect(FactoryGirl.build(:ship_position, timestamp: "2015-06-20T16:13:59")).to be_valid
    end
  end

end
