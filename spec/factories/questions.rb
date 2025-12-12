FactoryBot.define do
  factory :question do
    association :template
    text { "Pergunta Teste" }
    question_type { "text" }
    options { "" }
  end
end