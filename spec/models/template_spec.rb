##
# = Template Model Spec
#
# Suite de testes unitários para o modelo +Template+.
# Verifica as regras de validação e integridade dos dados, focando nos cenários de erro (Cenários Tristes).
#
require 'rails_helper'

RSpec.describe Template, type: :model do
  ##
  # == Contexto: Validações
  #
  # Agrupa os testes referentes às restrições de dados do modelo.
  context "Validações" do
    ##
    # Testa a obrigatoriedade do título.
    # Verifica se o modelo adiciona a mensagem de erro correta quando o título é nulo.
    it "é inválido sem título (Cenário Triste)" do
      template = Template.new(titulo: nil)
      template.valid?
      expect(template.errors[:titulo]).to include("O campo Título é obrigatório")
    end

    ##
    # Testa o formato do título.
    # Garante que caracteres especiais (como '@') não sejam aceitos.
    it "é inválido com caracteres especiais no título (Cenário Triste)" do
      template = Template.new(titulo: "Titulo@Invalido")
      template.valid?
      expect(template.errors[:titulo]).to include("Formato de título inválido")
    end

    ##
    # Testa a regra de negócio que exige questões no template.
    # Simula um template sem questões e verifica se o erro é adicionado à base do objeto.
    it "é inválido sem questões (Cenário Triste)" do
      template = Template.new(titulo: "Valido")
      # Simulando ausência de questões
      template.questions = []
      template.valid?
      expect(template.errors[:base]).to include("O template deve conter pelo menos uma questão")
    end
  end
end
