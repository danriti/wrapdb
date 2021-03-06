EasyApi::Application.routes.draw do
  #resources :projects

  # Current routes.
  match 'projects/create', to: 'projects#create'
  match 'projects/get', to: 'projects#get'

  match 'objects/create', to: 'object_defs#create'
  match 'objects/get', to: 'object_defs#get'

  match ':projectId/:objectDefName/insert', to: 'instances#insert'

  match ':projectId/endpoints/create', to: 'endpoints#create'
  match ':projectId/endpoints/get', to: 'endpoints#get'
  match ':projectId/:endpointName', to: 'endpoints#render_endpoint'

  # Old routes.
  root to: 'projects#index'

  match 'users/create', to: 'users#create'
  match 'users/get', to: 'users#get'

  match 'test/body', to: 'endpoints#test_body'
  match 'test', to: 'endpoints#test'

  # omniauth-github related routes.
  #match 'auth/:provider/callback', to: 'sessions#create'
  #match 'auth/failure', to: redirect('/')
  #match 'signout', to: 'sessions#destroy', as: 'signout'

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
