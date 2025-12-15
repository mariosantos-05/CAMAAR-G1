# Controller responsável pela criação de formulários administrativos
# a partir de templates e turmas selecionadas.
#
# Namespace: Admins
#
# @see Form
# @see Template
# @see Turma
class Admins::FormsController < ApplicationController
  # Exibe o formulário para criação de novos formulários administrativos.
  #
  # Carrega:
  # - Todos os templates disponíveis
  # - Apenas turmas ativas
  #
  # @return [void]
  def new
    load_templates
    load_active_turmas
  end

  # Cria formulários para as turmas selecionadas a partir de um template.
  #
  # Fluxo:
  # - Valida presença de template e turmas
  # - Cria um formulário para cada turma
  # - Redireciona com mensagem de sucesso ou erro
  #
  # @return [void]
  def create
    return render_invalid_selection unless valid_selection?

    create_forms_for_turmas
    redirect_to_success
  end

  private

  # Carrega todos os templates disponíveis.
  #
  # @return [void]
  def load_templates
    @templates = Template.all
  end

  # Carrega apenas turmas ativas.
  #
  # @return [void]
  def load_active_turmas
    @turmas = Turma.where(is_active: true)
  end

  # Verifica se o template e as turmas foram selecionados.
  #
  # @return [Boolean]
  def valid_selection?
    template_id.present? && turma_ids.any?
  end

  # Retorna o template selecionado.
  #
  # @return [String, nil]
  def template_id
    params[:template_id]
  end

  # Retorna os IDs das turmas selecionadas.
  #
  # @return [Array<String>]
  def turma_ids
    params[:turma_ids] || []
  end

  # Cria formulários ativos para cada turma selecionada.
  #
  # @return [void]
  def create_forms_for_turmas
    turma_ids.each do |turma_id|
      Form.create!(
        template_id: template_id,
        turma_id: turma_id,
        is_active: true
      )
    end
  end

  # Renderiza resposta de erro quando a seleção é inválida.
  #
  # @return [void]
  def render_invalid_selection
    flash.now[:alert] = "Selecione um template e pelo menos uma turma."

    respond_to do |format|
      format.turbo_stream { render_turbo_stream_error }
      format.html { redirect_to admin_management_path, alert: flash.now[:alert] }
    end
  end

  # Renderiza resposta Turbo Stream para erro de validação.
  #
  # @return [void]
  def render_turbo_stream_error
    render turbo_stream: [
      turbo_stream.remove("modal"),
      turbo_stream.replace(
        "flash_messages",
        partial: "shared/flash"
      )
    ]
  end

  # Redireciona para a tela de gestão com mensagem de sucesso.
  #
  # @return [void]
  def redirect_to_success
    redirect_to admin_management_path, notice: "Formulários criados com sucesso!"
  end
end
