##
# = Template Factory
#
# Define a estratégia de criação de objetos +Template+ para testes utilizando +FactoryBot+.
#
# == Hooks
#
# * +after(:build)+: Garante que um template sempre tenha ao menos uma questão
#   associada antes de ser salvo, satisfazendo a validação do modelo +Template+.
#
FactoryBot.define do
  factory :template do
    sequence(:titulo) { |n| "Template #{n}" }
    target_audience { "Alunos" }
    association :criado_por, factory: :usuario # Usa a factory de usuario/admin

    ##
    # Garante a integridade do modelo adicionando uma questão dummy.
    after(:build) do |template|
      # Adiciona 1 pergunta à lista de questions do template
      template.questions << build(:question, template: template)
    end
  end
end