Virtualwdc::Application.routes.draw do

  namespace :say_what do
    resources :drivers
  end


  resources :drivers do
    member do
      put 'claim'
    end
  end

  resources :laps, :tracks, :screenshots
  resources :users do
    collection do
      get 'sign_in'
      get 'sign_out'
      post 'do_sign_in'
    end
  end

  resources :leagues do
    resources :seasons
  end

  resources :seasons do
    resources :races
  end

  resources :races do
    resources :sessions
    member do
      get 'chart'
    end
  end

  resources :sessions do
    member do
      get 'chart'
    end
    collection do
      post 'register'
      post 'scan_time_trial'
    end
    resources :screenshots
  end

  namespace :say_what do
    resources :drivers, :super_leagues, :leagues, :seasons, :races, :sessions, :laps, :screenshots, :tracks
    get 'welcome', :to => 'welcome#index'
  end

  root :to => 'welcome#index'
end
