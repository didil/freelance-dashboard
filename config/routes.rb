FreelanceDashboard::Application.routes.draw do
  get "keywords_controller/create"

  get "home/index"

  get "job_feed/index"

  authenticated :user do
    root :to => 'job_feed#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users

  resources :keywords
end