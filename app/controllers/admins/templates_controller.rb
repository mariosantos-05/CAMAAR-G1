class Admins::TemplatesController < ApplicationController

  def index
    @templates = Template.all

    # Cenário: Visualizar lista vazia
    if @templates.empty?
      flash.now[:notice] = "Nenhum template foi criado"
    end
  end

  def new
    @template = Template.new
  end

  def create
    @template = Template.new(template_params)

    # Atribui o usuário logado
    @template.criado_por = current_user 

    # Simula questões vindas do form
    @template.questions = params[:template][:questions] 

    if @template.save
      redirect_to templates_path, notice: "Template criado com sucesso"
    else
      # Cenários tristes: Título vazio ou Sem questões
      flash.now[:alert] = @template.errors.full_messages.join(", ")
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @template = Template.find(params[:id])
  end

  def update
    @template = Template.find(params[:id])

    # Simula questões
    @template.questions = ["mock_question"] 


    if @template.update(template_params)
      redirect_to templates_path, notice: "Template atualizado com sucesso"
    else
      # Cenário Triste: Caracteres inválidos
      flash.now[:alert] = @template.errors.full_messages.first
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @template = Template.find(params[:id])
    @template.destroy
    redirect_to templates_path, notice: "Template removido com sucesso"
  end

  private

  def template_params
    params.require(:template).permit(:titulo, :target_audience)
  end
end