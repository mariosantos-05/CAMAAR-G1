require "ostruct"
class AvaliacoesController < ApplicationController
  before_action :require_user

  def index
    # Pega turmas que o usuário participa
    @turmas = current_user.vinculos.includes(turma: :forms).map(&:turma)

    # Carrega apenas os forms ativos de cada turma
    @turmas = @turmas.map do |turma|
      OpenStruct.new(
        id: turma.id,
        nome: turma.nome,
        semestre: turma.semestre,
        forms: turma.forms.where(is_active: true).map do |form|
          OpenStruct.new(
            id: form.id,
            titulo: form.template.titulo,
            turma_nome: turma.nome,
            semestre: turma.semestre
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
  end

  def enviar_resposta
    form = Form.find(params[:form_id])

    # Apenas usuários da turma podem enviar
    unless current_user.vinculos.exists?(turma_id: form.turma_id)
      redirect_to avaliacoes_path, alert: "Você não tem acesso a esse formulário."
      return
    end

    # Aqui você poderia salvar respostas, mas vamos deletar o form para teste
    form.destroy

    redirect_to avaliacoes_path, notice: "Formulário enviado com sucesso!"
  end

  private

  def require_user
    redirect_to "/", alert: "Fake user not configured." unless current_user
  end
end
