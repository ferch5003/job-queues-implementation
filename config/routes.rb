Rails.application.routes.draw do
  require 'sidekiq/web'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount Sidekiq::Web => '/queues'

  get '/', to: 'jobs_examples#index', as: 'jobs_examples'
  post 'execute-without-job', to: 'jobs_examples#execute_without_job', as: 'execute_without_job'
  post 'execute-with-job', to: 'jobs_examples#execute_with_job', as: 'execute_with_job'
end
