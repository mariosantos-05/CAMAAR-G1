class Resposta < ApplicationRecord
  belongs_to :form
  belongs_to :usuario

  # answers será um hash armazenado no campo JSON; garantimos um hash vazio por padrão
  def answers_hash
    (self.answers || {}).with_indifferent_access
  end
end
