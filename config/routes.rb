Rails.application.routes.draw do
  root 'questions#index'
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  get '/users/request_email', to: 'users#request_email', as: :request_email
  post '/users/finish_signup', to: 'users#finish_signup', as: :finish_signup

  concern :votable do
    member do
      patch :upvote, :downvote, :recall_vote
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
