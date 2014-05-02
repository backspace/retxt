ReTxt::Application.routes.draw do
  devise_for :users

  resources :subscribers
  resources :users
  resources :txts do
    post 'incoming', on: :collection
  end

  resources :setup

  root to: "home#index"
end
