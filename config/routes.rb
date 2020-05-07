Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :drivers, :passengers, :trips

  # Custom Routes
  patch '/drivers/:id/available', to: 'drivers#available', as: 'driver_available'



end
