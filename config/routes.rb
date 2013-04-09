FreelanceDashboard::Application.routes.draw do

  get "jobs/update" , :as => "jobs_update"

  get "keywords_controller/create"

  get "home/index"

  get "job_feed/index"
  get "job_feed/refresh" , :as => "refresh_job_feed"

  root :to => 'job_feed#index'

  devise_for :users
  resources :users

  resources :keywords
end