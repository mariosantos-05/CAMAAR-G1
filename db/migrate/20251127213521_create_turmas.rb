class CreateTurmas < ActiveRecord::Migration[8.0]
  def change
    create_table :turmas do |t|
      t.string :class_code
      t.string :semester
      t.string :time
      t.references :subject, null: false, foreign_key: true

      t.timestamps
    end
  end
end
