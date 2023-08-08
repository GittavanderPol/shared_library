Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "books#index"
  resources :books
  # GET /books => index
  # GET /books/new => new
  # GET /books/:id => show
  # POST /books => create
  # POST/PUT /books/:id => update
  # DELETE /books:id => destroy
end
