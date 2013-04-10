Sssr::Application.routes.draw do
  devise_for :users

  incoming_constraints = {}
  # incoming_constraints = {protocol: 'https'} if Rails.env.production?

  resources :subscribers
  resources :txts do
    post 'incoming', on: :collection, constraints: incoming_constraints
  end

  root to: "home#index"
end
