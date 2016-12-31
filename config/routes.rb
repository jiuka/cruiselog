require 'domain_constraint'

Rails.application.routes.draw do

  resources :passwords, controller: 'clearance/passwords', only: [:create, :new]
  resource :session, controller: 'clearance/sessions', only: [:create]

  resources :users, controller: 'clearance/users', only: [:create] do
    resource :password,
      controller: 'clearance/passwords',
      only: [:create, :edit, :update]
  end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'clearance/users#new', as: 'sign_up'

  constraints DomainConstraint.new('istnalaaufkreuzfahrt.ch') do
    root :to => 'ist_nala_auf_kreuzfahrt#index'
    get ':status' => 'ist_nala_auf_kreuzfahrt#index', as: 'ist_nala_auf_kreuzfahrt_status'
  end
  get 'ist_nala_auf_kreuzfahrt' => 'ist_nala_auf_kreuzfahrt#index'
  get 'ist_nala_auf_kreuzfahrt/:status' => 'ist_nala_auf_kreuzfahrt#index'

  get '/zuhause' => 'zuhause#index'

  resources :ships
  resources :cruises, path: '/'
end
