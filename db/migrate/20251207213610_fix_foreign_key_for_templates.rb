class FixForeignKeyForTemplates < ActiveRecord::Migration[8.0]
  def change
    # Remove foreign key incorreta
    remove_foreign_key :templates, column: :criado_por_id rescue nil

    # Adiciona foreign key correta
    add_foreign_key :templates, :usuarios, column: :criado_por_id
  end
end
