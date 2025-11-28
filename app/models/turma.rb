class Turma < ApplicationRecord
  belongs_to :subject
  has_and_belongs_to_many :members
end