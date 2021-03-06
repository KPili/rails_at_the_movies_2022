Rails.application.routes.draw do
  resources :pages, except: [:show]

  get "/pages/:permalink" => "pages#permalink", as: "permalink"
  # get "home/index"
  # get "production_companies/index"
  # get "production_companies/show"
  # get "movies/index"
  # get "movies/show"

  # implementing a route for the search feature
  resources :movies, only: %i[index show] do
    collection do
      get "search" # movies/search(:format) is now available in our route paths (rails/info)
    end
  end
  resources :production_companies, only: %i[index show]

  # Defines the root path route ("/")
  # root "articles#index"
  root to: "home#index"
end
