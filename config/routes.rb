# config/routes.rb
Rails.application.routes.draw do
  root to: 'search#index'

  get '/search' => 'search#search'
end