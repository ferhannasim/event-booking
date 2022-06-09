Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :tours
  resources :operators

  get '/get_tour_types' => 'tours#get_tour_types'
end
