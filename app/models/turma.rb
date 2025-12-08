class Turma < ApplicationRecord
    has_many :forms
    has_many :vinculos, dependent: :destroy
    has_many :usuarios, through: :vinculos
end
