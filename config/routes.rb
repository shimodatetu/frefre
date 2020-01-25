Rails.application.routes.draw do
  get 'users/test'
  get 'users/unsubscribe'
  get 'manager',to:"manager#show"
  get 'manager/show'
  get 'manager/search_post'
  get 'manager/search_post/:page' => 'manager#search_post'
  get 'manager/search_post_detail'
  get 'manager/search_post_detail/:id' => 'manager#search_post_detail'
  get 'manager/search_thread'
  get 'manager/search_thread/:page' => 'manager#search_thread'
  get 'manager/search_thread_detail'
  get 'manager/search_thread_detail/:id' => 'manager#search_thread_detail'
  get 'manager/search_user'
  get 'manager/search_user/:page' => 'manager#search_user'
  get 'manager/search_user_detail'
  get 'manager/search_user_detail/:id' => 'manager#search_user_detail'
  get 'manager/category' => 'manager#category_make'
  get 'manager/search_report_user'
  get 'manager/search_report_user/:page' => 'manager#search_user'
  get 'manager/search_report_user_detail'
  get 'manager/search_report_user_detail/:id' => 'manager#search_report_user_detail'

  get 'manager/search_report_post'
  get 'manager/search_report_post/:page' => 'manager#search_post'
  get 'manager/search_report_post_detail'
  get 'manager/search_report_post_detail/:id' => 'manager#search_report_post_detail'


  post 'threadtype_new',to:'manager#threadtype_new'
  get 'manager/user_office',to:'manager#user_office'
  get 'manager/user_office/:id' => 'manager#user_office'
  post 'user_info',to:'manager#user_info'

  get '/manager/prohibit'

  post 'mangaer/user_change', to:'manager#user_change'

  post 'mangaer/thread_delete', to:'manager#thread_delete'
  post 'mangaer/post_delete', to:'manager#post_delete'
  post 'searcher/groups',to:'manager#search'
  post '/manager/group',to:'manager#searcher_group'
  post '/manager/post',to:'manager#searcher_post'
  post '/manager/profile',to:'manager#searcher_profile'
  post '/manager/mail',to:'manager#searcher_mail'
  post '/manager/user',to:'manager#searcher_user'
  post '/manager/prohibit',to:'manager#prohibit_set'
  post '/manager/prohibit_delete',to:'manager#prohibit_delete'
  post '/manager/prohibit_alldelete',to:'manager#prohibit_alldelete'
  post '/manager/report_user',to:'manager#searcher_report_user'
  post '/manager/report_post',to:'manager#searcher_report_post'

  get 'auth/:provider/callback', to: 'sessions#login_auth'
  get '/users/auth/:provider/callback', to: 'sessions#login_auth'
  get 'auth/failure', to: redirect('/groups')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'sessions/index'
  get 'sessions/new'
  get '/sessions/event_login'
  get 'sessions/oauth_complete'
  post 'session/create_oauth'
  post 'create_oauth',to:'sessions#create_oauth'

  get "/oauth_complete", to:"sessions#oauth_complete"
  get    '/login',   to: 'sessions#index'
  post   '/login',   to: 'sessions#login_post'
  post   '/login2',   to: 'sessions#login_post2'
  delete '/logout',  to: 'sessions#destroy'



  get 'policy',to:'policy#show_policy'
  get 'term',to:'policy#show_term'
  get 'contact',to:'policy#contact'
  post 'contact/mail',to:'policy#mail'

  get 'notice/show/:id' => 'notice#show'
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
  match '/threadtype_new' => 'category#threadtype_new', via: [ :post ]
  match '/type_new' => 'category#type_new', via: [ :post ]
  get 'category/show'
  get 'category/show/:id' => 'category#show'
  get 'category/show/:id/:page' => 'category#show'
  get 'category/show2'

  post '/follow_other',to:'tasks#follow_other'
  post 'tasks/en',to:'tasks#lang_change_en'
  post 'tasks/jp',to:'tasks#lang_change_jp'
  post 'delete',to:'tasks#delete'
  post '/report/user',to:"tasks#report_user"
  post '/report/post',to:"tasks#report_post_task"

  post 'search/header',to:'tasks#search'

  post 'search/inside',to:'tasks#search_inside'
  post 'logout/inner',to:'tasks#logout_inner'
  get 'signup',to:'users#index'
  get 'thread/show/:id' => 'thread#show'
  get 'thread/show/:id/:page' => 'thread#show'
  get 'thread_all/show/:id' => 'thread_all#show'
  get 'posts/index'
  post "posts/trans"
  post "posts",to: "posts#create",as: "posts"
  post "chats",to: "chats#create",as: "chats"
  get '/profile',to: 'profile#show'
  get '/profile/:id' => 'profile#show'
  get '/profile/:id/:page1' => 'profile#show'
  get '/profile/:id/:page1/:page2' => 'profile#show'

  post "profile/retire",to: "profile#retire"
  patch '/profile', to: 'profile#update'
  get '/notice/new/:id' => 'notice#new'
  get '/groups',to:'groups#new'
  post 'groups' => "groups#create"
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
      get :following, :followers
    end
  end
  resources :relationships,       only: [:create, :destroy]
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
