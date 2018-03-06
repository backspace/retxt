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

  get 'spell', to: 'home#spell'
  get 'edit_spell', to: 'home#edit_spell'
  put 'save_spell', to: 'home#save_spell'
end
