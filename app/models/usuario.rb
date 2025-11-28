class Usuario < ApplicationRecord
    has_many :vinculos, dependent: :destroy
    has_many :turmas, through: :vinculos
end
