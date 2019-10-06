Rails.application.routes.draw do

  post 'user_info',to:'office#user_info'
  get 'user_office',to:'office#user_office'

  get 'policy',to:'policy#show_policy'
  get 'term',to:'policy#show_term'
  get 'contact',to:'policy#contact'
  post 'contact/mail',to:'policy#mail'

  get 'notice/show/:id' => 'notice#show'
  get 'other_profile/show'
  get 'account_activations/check'
  get 'password_resets/new'
  get 'password_resets/new_check'
  get 'password_resets/edit'
  get 'search/:page' => 'search#show'
  get 'search' => 'search#show'

  get 'category/new'
  get 'category/new2'
  get 'category/new3'
  get 'category/smallcategory/:id/:page' => 'category#smallcategory'
  get 'category/smallcategory/:id' => 'category#smallcategory'
  get 'category/typecategory/:id/:page' => 'category#typecategory'
  get 'category/typecategory/:id' => 'category#typecategory'
  match '/small_new' => 'category#small_new', via: [ :post ]
  match '/big_new' => 'category#big_new', via: [ :post ]
  match '/all_new' => 'category#all_new', via: [ :post ]
  match '/type_new' => 'category#type_new', via: [ :post ]
  get 'category/show'
  get 'category/show2'
  post 'tasks/en',to:'tasks#lang_change_en'
  post 'tasks/jp',to:'tasks#lang_change_jp'
  post 'delete',to:'tasks#delete'
  post 'search/header',to:'tasks#search'
  post 'search/inside',to:'tasks#search_inside'
  post 'logout/inner',to:'tasks#logout_inner'
  get 'signup',to:'users#index'
  get 'thread/show/:id' => 'thread#show'
  get 'thread/show/:id/:page' => 'thread#show'
  get 'thread_all/show/:id' => 'thread_all#show'
  get 'sessions/index'
  get 'posts/index'
  post "posts",to: "posts#create",as: "posts"
  post "chats",to: "chats#create",as: "chats"
  get '/profile',to: 'profile#show'
  get '/profile/:id' => 'profile#show'
  get '/profile/:id/:page1' => 'profile#show'
  get '/profile/:id/:page1/:page2' => 'profile#show'
  patch '/profile', to: 'profile#update'
  get '/notice/new/:id' => 'notice#new'
  get '/groups',to:'groups#new'
  post 'profile/send_img'
  get 'users/index'
  get 'users/term'
  get 'other_profile/show'
  get 'other_profile/:id' => 'other_profile#show'
  get 'other_profile', to:'other_profile#show'
  get 'thread_list/popular'
  get 'thread_list/new'
  get 'thread_list/popular/:id' => 'thread_list#popular'
  get 'thread_list/new/:id' => 'thread_list#new'
  resources :users
  resources :users do
    member do
      get "show_image"
    end
  end
  resources :notice
  resources :profile do
    member do
      get "show_image"
    end
  end
  resources :thread do
    member do
      get "show_post_image"
    end
  end
  resources :pv_page do
    member do
      get "show_image"
    end
  end
  get    '/login',   to: 'sessions#index'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  root 'pv_page#show'

  get 'home/:id' => 'pv_page#show'
  #root 'users#index'
  resources :password_resets,     only: [:new, :create, :edit, :update, :new_check]
  resources :account_activations, only: [:edit]
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
  mount ActionCable.server => '/cable'
end
