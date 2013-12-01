Virtualwdc::Application.routes.draw do

  resources :drivers do
    put 'claim'
  end

  resources :laps, :races
  resources :sessions do
    get 'chart'
  end

  root :to => 'sessions#index'
end
