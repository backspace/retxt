ReTxt::Application.routes.draw do
  devise_for :users

  resources :subscribers do
    resources :txts
  end

  resources :users

  resources :txts do
    post 'incoming', on: :collection
    post 'trigger', on: :collection
  end

  resources :meetings, only: [:show]

  resources :setup

  root to: "home#index"
end
