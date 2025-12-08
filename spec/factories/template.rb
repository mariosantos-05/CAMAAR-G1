FactoryBot.define do
  factory :template do
    sequence(:titulo) { |n| "Template #{n}" }
    target_audience { "Alunos de Engenharia" }
    association :criado_por, factory: :usuario, class: "Usuario"
  end
end
