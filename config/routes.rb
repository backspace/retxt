Sssr::Application.routes.draw do
  resources :subscribers
  resources :txts do
    post 'incoming', on: :collection
  end
end
