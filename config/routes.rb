Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  get 'gerenciamento', to: 'admins#management', as: 'admin_management'
  get 'importar_sigaa', to: 'admins#new_import', as: 'import_sigaa'
  post 'importar_sigaa', to: 'admins#create_import'


  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # Tela inicial (pode ser o login ou uma landing page)
  root 'sessions#new'

  # Issue #10: Login e Logout
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # Issue #11: Primeiro Acesso (Definição de Senha)
  resources :first_access, only: [:edit, :update]

  # Issue #6: Importação (Admin)
  get '/admin/import', to: 'imports#new', as: :admin_import
  post '/admin/import', to: 'imports#create'

  # Dashboards (apenas para redirecionamento)
  get '/dashboard_placeholder', to: proc { [200, {}, ['Avaliações (Em construção)']] }, as: :avaliacoes
  #get '/admin_placeholder', to: proc { [200, {}, ['Gerenciamento Admin (Em construção)']] }, as: :admin_management
end
