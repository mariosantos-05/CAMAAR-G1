FactoryBot.define do
  # Define explicitamente que esta factory cria um 'Usuario'
  factory :usuario, class: 'Usuario' do
    sequence(:nome) { |n| "Usuario Teste #{n}" }
    sequence(:matricula) { |n| "202500#{n}" }
    sequence(:email) { |n| "usuario#{n}@teste.com" }
    status { true }
    departamento_id { 1 }

    # SENHA FORTE: Para passar no regex do seu model
    password { "Teste@1234" }

    profile { "Aluno" }

    # Sub-factory para Admin
    factory :admin do
      nome { "Admin Teste" }
      profile { "Admin" }
      email { "admin@teste.com" }
    end
  end
end
