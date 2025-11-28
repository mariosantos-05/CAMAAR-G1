class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :nome
      t.string :matricula
      t.string :email
      t.boolean :status
      t.string :profile
      t.integer :departamento_id

      t.timestamps
    end
  end
end
