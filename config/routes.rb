Rails.application.routes.draw do

  resources :drivers, :only => [ :index, :show, :edit, :update ]
  resources :laps, :only => [ :create ]
  resources :tracks, :only => [ :index, :show ]
  resources :screenshots, :only => [ :index, :show, :edit, :update ]
  resources :users, :except => [ :destroy ] do
    collection do
      get 'sign_in'
      get 'sign_out'
      get 'sign_up', :to => 'users#new'
      post 'do_sign_in'
    end
    resources :sessions
  end

  resources :leagues, :only => [ :index, :show ]
  resources :seasons, :only => [ :show ]

  resources :races, :only => [ :index, :show ] do
    member do
      get 'livetiming'
    end
    collection do
      get 'without_sessions'
    end
  end

  resources :sessions do
    member do
      get 'chart'
    end
    collection do
      post 'register'
      get 'search'
    end
    resources :screenshots
  end

  namespace :say_what do
    resources :drivers, :super_leagues, :leagues, :seasons, :sessions, :laps, :screenshots, :tracks, :users
    resources :races do
      member do
        get 'rescan'
      end
    end
    get 'welcome', :to => 'welcome#index'
  end

  get 'help/aclog', :to => 'welcome#aclog'
  get 'help/rlcapp', :to => 'welcome#rlcapp'
  root :to => 'welcome#index'
end
