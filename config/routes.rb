Rails.application.routes.draw do
  root "books#index"
  resources :books, except: [:show]
  resources :users, only: [:index, :show]
  resources :connections, except: [:edit, :update, :destroy] do
    member do # DELETE connections/1
      post :accept, :decline, :cancel
    end
    collection do
      delete :unfriend
    end
  end

  devise_for :users, path: "auth"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
