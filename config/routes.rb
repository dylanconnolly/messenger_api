Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    namespace :v1 do
      post '/messages', to: 'messages#create'
      get '/messages', to: 'messages#index'
      get '/messages/:recipient/:sender', to: 'messages_between_users#index'
    end
  end
end
