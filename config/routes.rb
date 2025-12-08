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


end
