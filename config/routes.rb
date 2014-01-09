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
    resources :screenshots
  end

  root :to => 'sessions#index'
end
