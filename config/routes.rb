Rails.application.routes.draw do
  # Admin routes
  get 'gerenciamento', to: 'admins#management', as: 'admin_management'
  get 'importar_sigaa', to: 'admins#new_import', as: 'import_sigaa'
  post 'importar_sigaa', to: 'admins#create_import'

  get 'resultados', to: 'admins#results', as: 'admin_results'
  get 'resultados/:turma_id/csv', to: 'admins#export_csv', as: 'export_results_csv'

  namespace :admins do
    resources :templates
    resources :forms, only: [:new, :create]
  end

  get "avaliacoes", to: "avaliacoes#index", as: "avaliacoes"
  get "avaliacoes/:turma_id/forms/:form_id/responder",
      to: "avaliacoes#responder",
      as: "responder_form"

  post "avaliacoes/:form_id/enviar_resposta",
       to: "avaliacoes#enviar_resposta",
       as: "enviar_resposta_avaliacao"


  get "turmas/:id/respostas", to: "results#show_respostas", as: :turma_respostas

  get "admins/results/:turma_id/respostas",
    to: "admins#show_respostas",
    as: :admin_turma_respostas

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
  #get '/dashboard_placeholder', to: proc { [200, {}, ['Avaliações (Em construção)']] }, as: :avaliacoes
  #get '/admin_placeholder', to: proc { [200, {}, ['Gerenciamento Admin (Em construção)']] }, as: :admin_management
end
