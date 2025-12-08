require "ostruct"

class AvaliacoesController < ApplicationController
  before_action :require_user

  def index
    @turmas = current_user.vinculos.includes(turma: :forms).map(&:turma)

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

    # Verifica se o usuário participa da turma
    unless current_user.vinculos.exists?(turma_id: @form.turma_id)
      redirect_to avaliacoes_path, alert: "Você não tem acesso a esse formulário."
      return
    end

    # 🚨 Impede que responda mais de 1 vez
    if Resposta.exists?(form_id: @form.id, usuario_id: current_user.id)
      redirect_to avaliacoes_path, alert: "Você já respondeu este formulário."
      return
    end
  end

  def enviar_resposta
    form = Form.find(params[:form_id])

    # Verifica permissão
    unless current_user.vinculos.exists?(turma_id: form.turma_id)
      redirect_to avaliacoes_path, alert: "Você não tem acesso a esse formulário."
      return
    end

    # 🚨 Impede que o aluno envie novamente (segurança)
    if Resposta.exists?(form_id: form.id, usuario_id: current_user.id)
      redirect_to avaliacoes_path, alert: "Você já respondeu este formulário."
      return
    end

    normalized_answers = params[:answers] || {}

    # 👉 Aqui criamos o registro dizendo que ESTE aluno respondeu
    Resposta.create!(
      form_id: form.id,
      usuario_id: current_user.id,
      answers: normalized_answers
    )

    # ❗ Nada de destruir o form — cada aluno responde o mesmo form
    redirect_to avaliacoes_path, notice: "Formulário enviado com sucesso!"
  end
  
  
  private
  
  def answers_params
    params.require(:answers).permit!.to_h
  end


  private

  def require_user
    redirect_to "/", alert: "Fake user not configured." unless current_user
  end
end
