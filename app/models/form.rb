# Representa um formulário associado a um template e a uma turma.
#
# Cada Form é baseado em um Template, que define as perguntas do formulário,
# e está vinculado a uma Turma específica.
#
# Associations:
#   belongs_to :template - o modelo de perguntas e estrutura do formulário
#   belongs_to :turma    - a turma à qual o formulário pertence
class Form < ApplicationRecord
  belongs_to :template
  belongs_to :turma
end
