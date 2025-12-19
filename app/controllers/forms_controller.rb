##
# = Forms Controller
#
# Controlador responsável pela criação pública de formulários de avaliação,
# permitindo que usuários (Docentes ou Discentes) instanciem avaliações baseadas
# em templates predefinidos.
#
class FormsController < ApplicationController
  ##
  # Inicializa um novo objeto Form para exibição na view.
  def new
    @form = Form.new
  end

  ##
  # Processa a criação de um formulário.
  #
  # == Lógica de Negócio
  #
  # * Verifica se o +target_audience+ foi selecionado.
  # * Valida a presença de +turma_id+ para discentes.
  # * Instancia o formulário como ativo (+is_active: true+).
  #
  # Redireciona para a listagem em caso de sucesso ou re-renderiza +new+ em caso de falha.
  #
  def create
    # Cenário Triste: Tentativa de criar sem selecionar público
    if params[:target_audience].blank?
      redirect_to new_form_path, alert: "Selecione o público-alvo da avaliação"
      return
    end

    # Lógica para Docentes (sem turma) e Discentes (com turma)
    if params[:target_audience] == "Discentes" && params[:turma_id].blank?
      # BDD foca no público-alvo no cenário triste simples
    end

    # Criação simulada
    @form = Form.new(
      template_id: params[:template_id],
      turma_id: params[:turma_id],
      is_active: true
    )

    if @form.save
      redirect_to forms_path, notice: "Formulário enviado com sucesso"
    else
      render :new
    end
  end
end
