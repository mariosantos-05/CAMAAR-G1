FactoryBot.define do
  factory :vinculo do
    association :usuario
    association :turma
    papel_turma { 0 } # ex: 0 = aluno, 1 = professor
  end
end
