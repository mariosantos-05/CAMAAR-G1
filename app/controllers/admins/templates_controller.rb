##
# = Admins Templates Controller
#
# Gerencia as operações CRUD (Create, Read, Update, Delete) para o modelo +Template+
# dentro do namespace administrativo.
#
# Permite que administradores definam questionários e seu público-alvo.
#
class Admins::TemplatesController < ApplicationController
  # Refatoração 1: Centraliza a busca do template para evitar repetição (DRY)
  before_action :set_template, only: %i[show edit update destroy]

  ##
  # Lista todos os templates cadastrados no sistema.
  # Define uma mensagem flash se a lista estiver vazia.
  #
  # GET /admins/templates
  def index
    @templates = Template.all
    # Simplificação: Condicional em uma linha reduz a complexidade visual e lógica
    flash.now[:notice] = "Nenhum template foi criado" if @templates.empty?
  end

  ##
  # Exibe os detalhes de um template específico.
  #
  # GET /admins/templates/1
  def show
    # O @template já é definido pelo before_action
  end

  ##
  # Inicializa um novo template e constrói a primeira questão para o formulário aninhado.
  #
  # GET /admins/templates/new
  def new
    @template = Template.new
    @template.questions.build
  end

  ##
  # Exibe o formulário de edição para um template existente.
  #
  # GET /admins/templates/1/edit
  def edit
    # O @template já é definido pelo before_action
  end

  ##
  # Cria um novo template com base nos parâmetros fornecidos.
  # Associa o template ao usuário atual (+current_user+).
  #
  # Se falhar, renderiza a view +new+ com mensagens de erro.
  #
  # POST /admins/templates
  def create
    @template = Template.new(template_params)
    @template.criado_por = current_user

    if @template.save
      redirect_to admins_templates_path, notice: "Template criado com sucesso"
    else
      # Refatoração 2: Chama método privado para tratar erro
      render_error_response(:new)
    end
  end

  ##
  # Atualiza um template existente.
  #
  # Se falhar, renderiza a view +edit+ com mensagens de erro.
  #
  # PATCH/PUT /admins/templates/1
  def update
    if @template.update(template_params)
      redirect_to admins_templates_path, notice: "Template atualizado com sucesso"
    else
      # Refatoração 2: Reutiliza a lógica de erro
      render_error_response(:edit)
    end
  end

  ##
  # Remove permanentemente um template do banco de dados.
  #
  # DELETE /admins/templates/1
  def destroy
    if @template.destroy
      redirect_to admins_templates_path, notice: "Template removido com sucesso"
    else
      redirect_to admins_templates_path, alert: "Não foi possível remover o template."
    end
  end

  private

  ##
  # Busca o template pelo ID fornecido nos parâmetros.
  # Utilizado como +before_action+.
  def set_template
    @template = Template.find(params[:id])
  end

  ##
  # Configura as mensagens de erro e renderiza a view apropriada em caso de falha
  # na validação.
  #
  # Status retornado: +:unprocessable_entity+ (422).
  def render_error_response(view_template)
    flash.now[:alert] = @template.errors.map(&:message).uniq.join(", ")
    render view_template, status: :unprocessable_entity
  end

  ##
  # Strong Parameters para o Template.
  # Permite atributos aninhados para +questions+.
  def template_params
    params.require(:template).permit(
      :titulo,
      :target_audience,
      questions_attributes: %i[id text question_type options _destroy]
    )
  end
end