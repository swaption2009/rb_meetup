Rails.application.routes.draw do
  devise_for :users
  resources :events

  get 'tags/:tag', to: 'events#index', as: :tag
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
