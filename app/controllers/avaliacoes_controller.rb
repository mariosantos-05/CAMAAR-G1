require "ostruct"

class AvaliacoesController < ApplicationController
  before_action :require_user

  def index
    # Mock classes
    @turmas = [
      OpenStruct.new(
        id: 1,
        nome: "Cálculo I",
        forms: [
          OpenStruct.new(id: 11, titulo: "Avaliação do Professor"),
          OpenStruct.new(id: 12, titulo: "Avaliação da Disciplina")
        ]
      ),

    ]
  end


  def responder
    @form_id = params[:id]

    # mock form info
    @fake_form = OpenStruct.new(
      id: @form_id,
      titulo: "Pesquisa de Satisfação - Exemplo",
      turma_nome: "Turma Mockada"
    )
  end

  private

  def require_user
    redirect_to "/", alert: "Fake user not configured." unless current_user
  end
end
