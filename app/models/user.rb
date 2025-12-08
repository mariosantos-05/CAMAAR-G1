class User < ApplicationRecord
  has_secure_password # Exige a gem 'bcrypt'

  # Validações básicas para o teste passar
  validates :matricula, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :profile, presence: true
end