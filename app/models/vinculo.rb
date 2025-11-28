class Vinculo < ApplicationRecord
  belongs_to :usuario
  belongs_to :turma
end
