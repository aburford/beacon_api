Rails.application.routes.draw do
  post 'api/get_token'

  get 'api/hashes'

  post 'api/present'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
