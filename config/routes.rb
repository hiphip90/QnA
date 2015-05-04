Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :votable do
    member do
      patch :upvote, :downvote, :recall_vote
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, only: [:create, :destroy, :update], concerns: :votable do
      patch :accept, on: :member
    end
  end
end
