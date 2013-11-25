Virtualwdc::Application.routes.draw do

  resources :drivers do
    put 'claim'
  end

  resources :sessions, :laps, :races

  root :to => 'sessions#index'
end
