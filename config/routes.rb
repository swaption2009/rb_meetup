Rails.application.routes.draw do
  root 'events#index'

  devise_for :users

  resources :events do
    get :join, to: 'events#join', as: 'join'
    get :accept_request, to: 'events#accept_request', as: 'accept_request'
    get :reject_request, to: 'events#reject_request', as: 'reject_request'
  end

  get 'tags/:tag', to: 'events#index', as: :tag
  get :my_events, to: 'events#my_events', as: :my_events
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
