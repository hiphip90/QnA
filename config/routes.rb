Rails.application.routes.draw do
  get 'comments/create'

  devise_for :users
  root 'questions#index'

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
