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


    unless current_user.vinculos.exists?(turma_id: @form.turma_id)
      redirect_to avaliacoes_path, alert: "Você não tem acesso a esse formulário."
      return
    end

    if Resposta.exists?(form_id: @form.id, usuario_id: current_user.id)
      redirect_to avaliacoes_path, alert: "Você já respondeu este formulário."
      return
    end
  end

  def enviar_resposta
    form = Form.find(params[:form_id])


    unless current_user.vinculos.exists?(turma_id: form.turma_id)
      redirect_to avaliacoes_path, alert: "Você não tem acesso a esse formulário."
      return
    end

    if Resposta.exists?(form_id: form.id, usuario_id: current_user.id)
      redirect_to avaliacoes_path, alert: "Você já respondeu este formulário."
      return
    end

    
    
    normalized_answers = params[:answers]&.reject { |_k, v| v.blank? } || {}

  if normalized_answers.empty?
    redirect_to responder_form_path(form.turma_id, form.id),
                alert: "Preencha os campos obrigatórios."
    return
  end

   
    Resposta.create!(
      form_id: form.id,
      usuario_id: current_user.id,
      answers: normalized_answers
    )


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
