class AvaliacoesController < ApplicationController
  before_action :require_user

  def index
    if current_user&.profile == "Admin"
      # teacher/admin → classes they teach
      turmas_ids = current_user.vinculos.where(papel_turma: 1).pluck(:turma_id)
      @turmas = Turma.where(id: turmas_ids)
    else
      # student → classes they participate in
      turmas_ids = current_user&.vinculos&.pluck(:turma_id) || []
      @turmas = Turma.where(id: turmas_ids)
    end
  end

  private

  def require_user
    unless current_user
      redirect_to avaliacoes_path, alert: "Fake user not set. Use ENV['FAKE_ROLE'] = 'admin' or 'user'."
    end
  end
end
