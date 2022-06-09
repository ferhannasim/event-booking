FactoryBot.define do
  factory :tour do
    title { 'test' }
    start_datetime {'2022-06-15 12:51:00 UTC'}
    end_datetime {'2022-06-27 12:51:00 UTC'}
    tour_type {'Daily'}
  end
end
