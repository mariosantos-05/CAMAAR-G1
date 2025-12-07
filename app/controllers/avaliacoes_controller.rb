require "ostruct"
class AvaliacoesController < ApplicationController
  before_action :require_user

  def index
    # Pega turmas que o usuário participa
    @turmas = current_user.vinculos.includes(turma: :forms).map(&:turma)

    # Carrega os forms ativos de cada turma
    @turmas = @turmas.map do |turma|
      OpenStruct.new(
        id: turma.id,
        nome: turma.nome,
        forms: turma.forms.where(is_active: true).map do |form|
          OpenStruct.new(
            id: form.id,
            titulo: form.template.titulo
          )
        end
      )
    end
  end

  def responder
    @form = Form.includes(:template, :turma).find(params[:form_id])

    # Apenas permite acessar se o usuário faz parte da turma
    unless current_user.vinculos.exists?(turma_id: @form.turma_id)
      redirect_to avaliacoes_path, alert: "Você não tem acesso a esse formulário."
      return
    end

    @fake_form = OpenStruct.new(
      id: @form.id,
      titulo: @form.template.titulo,
      turma_nome: @form.turma.nome
    )
  end

  private

  def require_user
    redirect_to "/", alert: "Fake user not configured." unless current_user
  end
end
