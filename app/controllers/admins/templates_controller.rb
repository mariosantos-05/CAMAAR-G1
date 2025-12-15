class Admins::TemplatesController < ApplicationController
  # Refatoração 1: Centraliza a busca do template para evitar repetição (DRY)
  before_action :set_template, only: %i[show edit update destroy]

  # GET /admins/templates
  def index
    @templates = Template.all
    # Simplificação: Condicional em uma linha reduz a complexidade visual e lógica
    flash.now[:notice] = "Nenhum template foi criado" if @templates.empty?
  end

  # GET /admins/templates/1
  def show
    # O @template já é definido pelo before_action
  end

  # GET /admins/templates/new
  def new
    @template = Template.new
    @template.questions.build
  end

  # GET /admins/templates/1/edit
  def edit
    # O @template já é definido pelo before_action
  end

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

  # PATCH/PUT /admins/templates/1
  def update
    if @template.update(template_params)
      redirect_to admins_templates_path, notice: "Template atualizado com sucesso"
    else
      # Refatoração 2: Reutiliza a lógica de erro
      render_error_response(:edit)
    end
  end

  # DELETE /admins/templates/1
  def destroy
    if @template.destroy
      redirect_to admins_templates_path, notice: "Template removido com sucesso"
    else
      redirect_to admins_templates_path, alert: "Não foi possível remover o template."
    end
  end

  private

  # Método extraído para reduzir 'Assignments' e 'Branches' nos métodos principais
  def set_template
    @template = Template.find(params[:id])
  end

  def render_error_response(view_template)
    flash.now[:alert] = @template.errors.map(&:message).uniq.join(", ")
    render view_template, status: :unprocessable_entity
  end

  def template_params
    params.require(:template).permit(
      :titulo,
      :target_audience,
      questions_attributes: %i[id text question_type options _destroy]
    )
  end
end
