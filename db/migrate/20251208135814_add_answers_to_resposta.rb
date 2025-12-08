class AddAnswersToResposta < ActiveRecord::Migration[8.0]
  def change
    add_column :resposta, :answers, :json
  end
end
