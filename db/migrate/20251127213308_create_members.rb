class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.string :nome
      t.string :matricula
      t.string :curso
      t.string :usuario
      t.string :formacao
      t.string :ocupacao
      t.string :email

      t.timestamps
    end
  end
end
