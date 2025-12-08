class Template < ApplicationRecord
  belongs_to :criado_por, class_name: "Usuario"
  has_many :questions, dependent: :destroy
end
