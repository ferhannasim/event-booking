require 'rails_helper'

RSpec.describe ToursController, type: :controller do

  describe '#index' do
    context 'renders index page successfully' do
      before { get :index }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template('index') }
    end
  end

  describe '#new' do
    context 'renders new page successfully' do
      before { get :new }

      it { expect(response).to have_http_status(:ok) }
      it { expect(response).to render_template('new') }
    end
  end

  describe '#get_tour_types' do
    context 'renders new page successfully' do
      before { get :get_tour_types, params: { start_date: '2022/06/13 13:00'}, xhr: true }

      it do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#destroy' do
    let!(:tour) { create :tour }

    context 'destroys tour successfully' do
      before { delete :destroy, params: { id: tour.id } }

      it do
        expect(response).to redirect_to tours_path
      end
    end
  end

  describe '#create' do
    context 'when recurring type is never' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'Daily', recurring: 'Never' }}}

      it { expect(Tour.last.tour_type).to eq('Daily') }
    end

    context 'when recurring times is passed with daily tour type' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'Daily', recurring: 'No. of occurences', recurring_times: 2 }}}

      it do
        expect(Tour.count).to eq(2)
      end
    end

    context 'when recurring times is passed with weekly tour type' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'Weekly on Monday', recurring: 'No. of occurences', recurring_times: 2 }}}

      it { expect(Tour.count).to eq(2) }
    end

    context 'when recurring times is passed with monthly date tour type' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'Monthly on Every 13', recurring: 'No. of occurences', recurring_times: 2 }}}

      it { expect(Tour.count).to eq(2) }
    end

    context 'when recurring times is passed with  monthly day tour type' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'on Every 2 Monday', recurring: 'No. of occurences', recurring_times: 2 }}}

      it do 
         expect(Tour.count).to eq(3) 
      end
    end

    context 'when recurring times is passed with annaully tour type' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'Annually on June 13', recurring: 'No. of occurences', recurring_times: 2 }}}

      it do 
         expect(Tour.count).to eq(3) 
      end
    end

    context 'when recurring date is passed with daily tour type' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'Daily', recurring: 'Fill Occurence date', recurring_date: '2022/06/30 13:25' }}}

      it do 
         expect(Tour.count).to eq(17) 
      end
    end

    context 'when recurring date is passed with weekly tour type' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'Weekly on Monday', recurring: 'Fill Occurence date', recurring_date: '2022/08/30 13:25' }}}

      it { expect(Tour.count).to eq(11) }
    end

    context 'when recurring date is passed with monthly date tour type' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'Monthly on Every 13', recurring: 'Fill Occurence date', recurring_date: '2022/08/30 13:25' }}}

      it { expect(Tour.count).to eq(2) }
    end

    context 'when recurring date is passed with monthly day tour type' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'on Every 2 Monday', recurring: 'Fill Occurence date', recurring_date: '2022/08/30 13:25' }}}

      it { expect(Tour.count).to eq(3) }
    end

    context 'when recurring date is passed with annaully tour type' do
      before { post :create, params: { tour: { start_datetime: '2022/06/13 13:00', end_datetime: '2022/06/27 13:00', tour_type: 'Annually on June 13', recurring: 'Fill Occurence date', recurring_date: '2025/08/30 13:25' }}}

      it { expect(Tour.count).to eq(4) }
    end
  end
end