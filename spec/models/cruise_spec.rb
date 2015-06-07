require 'rails_helper'

RSpec.describe Cruise, type: :model do
  it 'should have valid factory' do
    expect(FactoryGirl.build(:cruise)).to be_valid
  end

  it 'should validate date order' do
    expect(FactoryGirl.build(:cruise, start_at: DateTime.now, end_at: DateTime.now-1.day)).not_to be_valid
  end
end
