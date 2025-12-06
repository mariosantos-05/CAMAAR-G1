require "ostruct"

class Admins::FormsController < ApplicationController
  def new
    # Load real templates
    @templates = Template.all

    # If none exist yet, create mock temporary objects (NOT saved in DB)
    if @templates.empty?
      @templates = [
        OpenStruct.new(id: 1, titulo: "Template de Avaliação - Geral"),
        OpenStruct.new(id: 2, titulo: "Template de Professores"),
        OpenStruct.new(id: 3, titulo: "Template de Autoavaliação")
      ]
    end

    @turmas = Turma.where(is_active: true)
  end

  def create
    template_id = params[:template_id]
    turma_ids   = params[:turma_ids] || []

    if template_id.blank? || turma_ids.empty?
      redirect_to new_admin_form_path, alert: "Selecione um template e pelo menos uma turma."
      return
    end

    turma_ids.each do |tid|
      Form.create!(
        template_id: template_id,
        turma_id: tid,
        is_active: true
      )
    end

    redirect_to admin_management_path, notice: "Formulários criados com sucesso!"
  end
end
