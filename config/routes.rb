require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root 'questions#index'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  get '/users/request_email', to: 'users#request_email', as: :request_email
  post '/users/finish_signup', to: 'users#finish_signup', as: :finish_signup

  concern :votable do
    member do
      patch :upvote, :downvote, :recall_vote
    end
  end
  
  namespace :api do
    namespace :v1 do
      resource :profiles do
        get :me, :all, on: :collection
      end

      resources :questions do
        resources :answers
      end
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, defaults: { commentable: 'question' }
    resources :answers, shallow: true, only: [:create, :destroy, :update], concerns: :votable do
      resources :comments, defaults: { commentable: 'answer' }
      patch :accept, on: :member
    end
  end
end
