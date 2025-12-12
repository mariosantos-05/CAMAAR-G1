FactoryBot.define do
  factory :template do
    sequence(:titulo) { |n| "Template #{n}" }
    target_audience { "Alunos" }
    association :criado_por, factory: :usuario # Usa a factory de usuario/admin

    # A MÁGICA ACONTECE AQUI:
    # Antes de tentar salvar o template no banco, ele cria uma pergunta na memória
    after(:build) do |template|
      # Adiciona 1 pergunta à lista de questions do template
      template.questions << build(:question, template: template)
    end
  end
end