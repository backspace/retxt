Sssr::Application.routes.draw do
  resources :txts do
    post 'incoming', on: :collection
  end
end
