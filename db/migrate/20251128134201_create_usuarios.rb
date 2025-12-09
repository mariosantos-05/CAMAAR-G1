class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :nome
      t.string :matricula
      t.string :email
      t.string :password_digest
      t.boolean :status, default: false
      t.string :profile
      t.integer :departamento_id

      t.timestamps
    end
    add_index :usuarios, :matricula, unique: true
    add_index :usuarios, :email, unique: true
  end
end
