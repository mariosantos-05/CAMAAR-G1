class Template < ApplicationRecord
  belongs_to :criado_por, class_name: "Usuario"
end
