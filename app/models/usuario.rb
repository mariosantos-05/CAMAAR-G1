class Usuario < ApplicationRecord
    has_many :vinculos, dependent: :destroy
    has_many :turmas, through: :vinculos
    has_secure_password validations: false
    # Validações básicas para o teste passar
    validates :password, presence: true, on: :create # Presença obrigatória apenas na criação (:create)
    validates :password, length: { minimum: 8 }, allow_nil: true
    validate :password_complexity, if: -> { password.present? }
    validates :matricula, presence: true, uniqueness: true
    validates :email, presence: true, uniqueness: true
    validates :profile, presence: true
    validates :nome, presence: true

    def password_complexity
    return if password =~ /^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9]).{8,}$/
    errors.add :password, 'deve ter no mínimo 8 caracteres, maiúsculas, minúsculas e números'
  end
end
