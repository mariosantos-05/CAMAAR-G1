class CreateTurmas < ActiveRecord::Migration[8.0]
  def change
    create_table :turmas do |t|
      t.string :nome
      t.string :semestre
      t.boolean :is_active

      t.timestamps
    end
  end
end
