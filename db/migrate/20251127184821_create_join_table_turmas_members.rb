class CreateJoinTableTurmasMembers < ActiveRecord::Migration[8.0]
  def change
    create_join_table :turmas, :members do |t|
      # t.index [:turma_id, :member_id]
      # t.index [:member_id, :turma_id]
    end
  end
end
