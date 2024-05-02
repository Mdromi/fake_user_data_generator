Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "fake_data_generator#index"
  post "/generate-data", to: "fake_data_generator#generate_data"
  post "/generate-random-seed", to: "fake_data_generator#generate_random_seed_data"
  post "/load-more-data", to: "fake_data_generator#load_more_data"

  get "/export-csv", to: "fake_data_generator#export_csv"
end
