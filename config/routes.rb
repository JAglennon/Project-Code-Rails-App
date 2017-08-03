Rails.application.routes.draw do
	
  resources :children, param: :id
  resources :child, param: :id
 
  resources :android, param: :token

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
 post '/children/android' => 'children#android'
 	
 post '/android' => 'android#create'
end
