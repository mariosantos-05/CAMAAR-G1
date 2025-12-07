require 'rails_helper'

RSpec.describe Template, type: :model do

  context "Validações" do
    it "é inválido sem título (Cenário Triste)" do
      template = Template.new(titulo: nil)
      template.valid?
      expect(template.errors[:titulo]).to include("O campo Título é obrigatório")
    end

    it "é inválido com caracteres especiais no título (Cenário Triste)" do
      template = Template.new(titulo: "Titulo@Invalido")
      template.valid?
      expect(template.errors[:titulo]).to include("Formato de título inválido")
    end

    it "é inválido sem questões (Cenário Triste)" do
      template = Template.new(titulo: "Valido")
      # Simulando ausência de questões
      template.questions = [] 
      template.valid?
      expect(template.errors[:base]).to include("O template deve conter pelo menos uma questão")
    end
  end
end
