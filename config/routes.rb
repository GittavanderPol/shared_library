Rails.application.routes.draw do
  root "books#index"
  resources :books
  devise_for :users, path: "auth"

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
