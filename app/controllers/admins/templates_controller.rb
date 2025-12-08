class Admins::TemplatesController < ApplicationController
  
  def index
    @templates = Template.all

    if @templates.empty?
      flash.now[:notice] = "Nenhum template foi criado"
    end
  end

  def show
    @template = Template.find(params[:id])
  end

  def new
    @template = Template.new

    @template.questions.build 
  end

  def create
    @template = Template.new(template_params)
    @template.criado_por = current_user 

    if @template.save
      redirect_to admins_templates_path, notice: "Template criado com sucesso"
    else

      flash.now[:alert] = @template.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @template = Template.find(params[:id])
  end

  def update
    @template = Template.find(params[:id])

    if @template.update(template_params)
      redirect_to admins_templates_path, notice: "Template atualizado com sucesso"
    else
      flash.now[:alert] = @template.errors.full_messages.join(", ")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template = Template.find(params[:id])
    if @template.destroy
      redirect_to admins_templates_path, notice: "Template removido com sucesso"
    else
      redirect_to admins_templates_path, alert: "Não foi possível remover o template."
    end
  end

  private

  def template_params

    params.require(:template).permit(
      :titulo, 
      :target_audience, 
      questions_attributes: [:id, :text, :question_type, :options, :_destroy]
    )
  end
end
