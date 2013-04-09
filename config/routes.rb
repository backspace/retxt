Sssr::Application.routes.draw do
  devise_for :users

  resources :subscribers
  resources :txts do
    post 'incoming', on: :collection
  end

  root to: "home#index"
end
