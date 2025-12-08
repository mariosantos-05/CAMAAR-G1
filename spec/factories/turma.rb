FactoryBot.define do
  factory :turma do
    sequence(:nome) { |n| "Turma #{n}" }
    semestre { "2025.2" }
    is_active { true }
  end
end
