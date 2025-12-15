FactoryBot.define do
  factory :resposta do
    association :form

    # ADICIONE ISTO: Cria um usuário automaticamente para ser o dono da resposta
    association :usuario

    answers { {} }
  end
end
