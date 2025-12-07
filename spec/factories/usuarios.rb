FactoryBot.define do
  factory :usuario do
    sequence(:nome) { |n| "Usuario Teste #{n}" }
    sequence(:matricula) { |n| "000#{n}" }
    sequence(:email) { |n| "usuario#{n}@teste.com" }
    status { true }
    profile { "aluno" }
    departamento_id { 1 }  # ajuste conforme necessário
  end

  factory :admin, class: "Usuario" do
    nome { "Admin Teste" }
    matricula { "0000" }
    email { "admin@teste.com" }
    status { true }
    profile { "admin" }
    departamento_id { 1 }
  end
end
