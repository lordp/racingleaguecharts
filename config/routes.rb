Virtualwdc::Application.routes.draw do

  get "welcome/index"

  resources :drivers do
    member do
      put 'claim'
    end
  end

  resources :laps, :tracks
  resources :super_leagues do
    resources :leagues do
      resources :seasons do
        resources :races do
          member do
            get 'chart'
          end
        end
      end
    end
  end

  resources :leagues do
    resources :seasons
  end

  resources :seasons do
    resources :races
  end

  resources :races do
    member do
      get 'chart'
    end
  end

  resources :sessions do
    member do
      get 'chart'
    end
    resources :screenshots
  end

  resources :screenshots

  root :to => 'welcome#index'
end
