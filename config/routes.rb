Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    root to: 'home#index'
    get 'welcome', to: 'home#index'

    # Users controller routes
    get 'sign_up', to: 'users#new'
    post 'sign_up', to: 'users#create'

    # Sessions controller routes
    get 'login', to: 'sessions#new'
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy'

    resource :user, only: %i[edit update]

    # Steps controller routes
    resources :steps, only: %i[show update edit] do
      collection do
        get 'check_your_answers', to: 'steps#check_your_answers'
        get 'results', to: 'steps#results'
        get 'scoreboard', to: 'steps#scoreboard'
        get 'download', to: 'steps#download'
      end
    end
  end

  # Catch-all route for handling 404 Not Found
  match '*path', to: 'application#render_404', via: :all
end
