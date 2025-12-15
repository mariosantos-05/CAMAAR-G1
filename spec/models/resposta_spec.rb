require 'rails_helper'

RSpec.describe Resposta, type: :model do
  let(:aluno) { create(:usuario, profile: 'Aluno') }
  let(:turma) { create(:turma) }
  let(:template) { create(:template, criado_por: create(:admin)) }
  let(:form) { create(:form, turma: turma, template: template) }

  context "Associações" do
    it "pertence a um usuário" do
      assoc = Resposta.reflect_on_association(:usuario)
      expect(assoc.macro).to eq :belongs_to
    end

    it "pertence a um form" do
      assoc = Resposta.reflect_on_association(:form)
      expect(assoc.macro).to eq :belongs_to
    end
  end

  describe "#answers_hash" do
    it "retorna um hash vazio se o campo answers for nil" do
      resposta = build(:resposta, form: form, usuario: aluno, answers: nil)

      expect(resposta.answers_hash).to eq({})
    end

    it "permite acesso com chave de string ou símbolo (Indifferent Access)" do
      dados = { "pergunta_1" => "Sim" }
      resposta = build(:resposta, form: form, usuario: aluno, answers: dados)

      hash = resposta.answers_hash

      expect(hash["pergunta_1"]).to eq("Sim")
      expect(hash[:pergunta_1]).to eq("Sim")
    end
  end
end
