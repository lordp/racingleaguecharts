Virtualwdc::Application.routes.draw do

  resources :drivers do
    member do
      put 'claim'
    end
  end

  resources :laps, :races
  resources :sessions do
    member do
      get 'chart'
    end
  end

  root :to => 'sessions#index'
end
