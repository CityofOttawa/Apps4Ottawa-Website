Apps4ottawa::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.


  scope "/(:locale)", :constraints => {:locale => /en|fr/} do
    devise_for :users

    resources :idea_comments
    resources :app_comments

    resources :ideas do
      member do
        put :like
      end
    end

    resources :apps do
      member do
        put :like
      end
    end

    resources :about do
      collection do
        get :index
        get :faq
        get :rules
        get :terms
        get :privacy
      end
    end

    root :to => 'main#index'
  end

end
