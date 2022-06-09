require 'rails_helper'

RSpec.describe Tour, :type => :model do

  context 'when end date is smaller than start date are valid' do
    let!(:tour) { build :tour, start_datetime: '2022-06-15 12:51:00 UTC', end_datetime: '2022-06-12 12:51:00 UTC' }

    it "returns error of smaller end datetime" do
      expect(tour.save).to eq(false)
    end
  end

  context 'when recurring date is blank' do
    let!(:tour) { build :tour, recurring_date: nil, recurring: 'On' }

    it "returns error of smaller end datetime" do
      expect(tour.save).to eq(false)
    end
  end

  context 'calculate tour length' do
    let!(:tour) { create :tour }

    it "returns error of smaller end datetime" do
      expect(tour.tour_length).to eq('1 Week and 5 Days')
    end
  end
end
