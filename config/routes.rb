Rails.application.routes.draw do
  # get "production_companies/index"
  # get "production_companies/show"
  # get "movies/index"
  # get "movies/show"

  resources :movies, only: %i[index show]
  resources :production_companies, only: %i[index show]

  # Defines the root path route ("/")
  # root "articles#index"
end
