Rails.application.routes.draw do
  get 'comments/create'

  devise_for :users
  root 'questions#index'

  concern :votable do
    member do
      patch :upvote, :downvote, :recall_vote
    end
  end

  concern :commentable do
    resource :comments
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, only: [:create, :destroy, :update], concerns: [:votable, :commentable] do
      patch :accept, on: :member
    end
  end
end
