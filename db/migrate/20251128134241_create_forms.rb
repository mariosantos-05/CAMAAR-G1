class CreateForms < ActiveRecord::Migration[8.0]
  def change
    create_table :forms do |t|
      t.references :template, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      t.boolean :is_active

      t.timestamps
    end
  end
end
