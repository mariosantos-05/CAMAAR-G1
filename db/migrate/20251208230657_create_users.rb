class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :matricula
      t.string :email
      t.string :password_digest
      t.boolean :status, default: false # false = Pendente, true = Ativo
      t.string :profile # 'Admin', 'Aluno', 'Professor'

      t.timestamps
    end
    # Garante unicidade no banco de dados
    add_index :users, :matricula, unique: true
    add_index :users, :email, unique: true
  end
end
