Rails.application.routes.draw do
  devise_for :admins
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  get 'projects/new'
  post 'projects/create'
  get 'projects/show'
  devise_for :users, controllers: { 
		registrations: 'users/registrations', 
		sessions: 'users/sessions'
	}
  get 'welcome/index'
  root 'projects#new'
  get 'project_stats/show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
