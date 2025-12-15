# Representa a resposta de um usuário a um formulário.
#
# Cada resposta pertence a um formulário (Form) e a um usuário (Usuario).
# O campo `answers` armazena um hash JSON com as respostas enviadas pelo usuário.
#
# Associations:
#   belongs_to :form    - o formulário respondido
#   belongs_to :usuario - o usuário que respondeu
#
# Methods:
#   answers_hash -> retorna o hash de respostas garantindo keys acessíveis de forma indiferente (Symbol/String)
class Resposta < ApplicationRecord
  belongs_to :form
  belongs_to :usuario

  # Retorna o hash de respostas com keys acessíveis por string ou símbolo
  #
  # @return [Hash] respostas enviadas pelo usuário, vazio se nenhuma resposta
  def answers_hash
    (self.answers || {}).with_indifferent_access
  end
end
