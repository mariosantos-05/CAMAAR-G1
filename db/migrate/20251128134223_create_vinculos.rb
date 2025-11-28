class CreateVinculos < ActiveRecord::Migration[8.0]
  def change
    create_table :vinculos do |t|
      t.references :usuario, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.integer :papel_turma

      t.timestamps
    end
  end
end
