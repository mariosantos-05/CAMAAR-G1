FactoryBot.define do
  factory :form do
    association :template
    association :turma
    is_active { true }
  end
end
