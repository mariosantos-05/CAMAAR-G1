Rails.application.routes.draw do
  get 'gerenciamento', to: 'admins#management', as: 'admin_management'
  get 'importar_sigaa', to: 'admins#new_import', as: 'import_sigaa' 
  post 'importar_sigaa', to: 'admins#create_import'

  get 'resultados', to: 'admins#results', as: 'admin_results'
  get 'resultados/:turma_id/csv', to: 'admins#export_csv', as: 'export_results_csv'

  namespace :admins do
    resources :forms, only: [:new, :create]
  end

  # NEW — route to render the form answering page
  get "avaliacoes/:turma_id/forms/:form_id/responder",
      to: "avaliacoes#responder",
      as: "responder_form"

  get "avaliacoes", to: "avaliacoes#index", as: "avaliacoes"
end
