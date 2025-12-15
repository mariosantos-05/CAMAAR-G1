require "ostruct"

# Controller responsável por gerenciar avaliações e respostas dos usuários.
class AvaliacoesController < ApplicationController
  # Garante que o usuário esteja autenticado antes de qualquer ação.
  before_action :require_user

  # Lista todas as turmas do usuário com seus formulários ativos
  #
  # @return [Array<OpenStruct>] Array de turmas com formulários ativos
  # @note Cada turma é representada como OpenStruct com id, nome, semestre e forms.
  def index
    @turmas = current_user_turmas_with_active_forms
  end

  # Exibe o formulário para o usuário responder
  #
  # @param params[:form_id] [Integer] ID do formulário a ser respondido
  # @return [void]
  # @note Redireciona o usuário caso ele não tenha acesso ou já tenha respondido.
  def responder
    @form = Form.includes(:template, :turma).find(params[:form_id])

    return redirect_with_alert("Você não tem acesso a esse formulário.") unless user_has_access?(@form)
    return redirect_with_alert("Você já respondeu este formulário.") if already_responded?(@form)
  end

  # Processa o envio das respostas do formulário
  #
  # @param params[:form_id] [Integer] ID do formulário
  # @param params[:answers] [Hash] Respostas enviadas pelo usuário
  # @return [void]
  # @note Cria um registro de Resposta no banco de dados. Redireciona em caso de erros ou sucesso.
  def enviar_resposta
    form = Form.find(params[:form_id])

    return redirect_with_alert("Você não tem acesso a esse formulário.") unless user_has_access?(form)
    return redirect_with_alert("Você já respondeu este formulário.") if already_responded?(form)

    answers = normalized_answers
    if answers.empty?
      return redirect_to responder_form_path(form.turma_id, form.id),
                         alert: "Preencha os campos obrigatórios."
    end

    Resposta.create!(form_id: form.id, usuario_id: current_user.id, answers: answers)
    redirect_to avaliacoes_path, notice: "Formulário enviado com sucesso!"
  end

  private

  # Normaliza as respostas removendo valores em branco
  #
  # @return [Hash] Respostas válidas
  def normalized_answers
    params[:answers]&.reject { |_k, value| value.blank? } || {}
  end

  # Verifica se o usuário tem acesso a um formulário
  #
  # @param form [Form] Formulário a ser verificado
  # @return [Boolean] true se o usuário possui vínculo com a turma
  def user_has_access?(form)
    current_user.vinculos.exists?(turma_id: form.turma_id)
  end

  # Verifica se o usuário já respondeu ao formulário
  #
  # @param form [Form] Formulário a ser verificado
  # @return [Boolean] true se já existe uma resposta do usuário
  def already_responded?(form)
    Resposta.exists?(form_id: form.id, usuario_id: current_user.id)
  end

  # Redireciona para a página de avaliações com alerta
  #
  # @param message [String] Mensagem de alerta
  # @return [void]
  def redirect_with_alert(message)
    redirect_to avaliacoes_path, alert: message
  end

  # Retorna todas as turmas do usuário com seus formulários ativos como OpenStruct
  #
  # @return [Array<OpenStruct>] Turmas com formulários ativos
  def current_user_turmas_with_active_forms
    current_user.vinculos.includes(turma: :forms).map(&:turma).map do |turma|
      turma_struct(turma)
    end
  end

  # Converte uma turma em OpenStruct com formulários ativos
  #
  # @param turma [Turma] Objeto turma
  # @return [OpenStruct] Turma com id, nome, semestre e forms
  def turma_struct(turma)
    OpenStruct.new(
      id: turma.id,
      nome: turma.nome,
      semestre: turma.semestre,
      forms: active_forms_struct(turma)
    )
  end

  # Converte os formulários ativos de uma turma em OpenStruct
  #
  # @param turma [Turma] Objeto turma
  # @return [Array<OpenStruct>] Formulários ativos da turma
  def active_forms_struct(turma)
    turma.forms.where(is_active: true).map do |form|
      OpenStruct.new(
        id: form.id,
        titulo: form.template.titulo,
        turma_nome: turma.nome,
        semestre: turma.semestre
      )
    end
  end

  # Verifica se existe um usuário autenticado
  #
  # @return [void]
  # @note Redireciona para a raiz caso o usuário não esteja logado
  def require_user
    redirect_to "/", alert: "Fake user not configured." unless current_user
  end
end
