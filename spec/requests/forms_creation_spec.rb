require 'rails_helper'

RSpec.describe "Form Creation", type: :request do
  describe "POST /forms" do
    context "Cenário Feliz: Enviar para Discentes com turma" do
      it "envia formulário com sucesso" do
        allow_any_instance_of(Form).to receive(:save).and_return(true)
        post forms_path, params: { target_audience: "Discentes", turma_id: "1", template_id: "1" }
        expect(response).to redirect_to(forms_path)
      end
    end

    context "Cenário Feliz: Enviar para Docentes" do
      it "envia formulário ignorando turma se necessário" do
        allow_any_instance_of(Form).to receive(:save).and_return(true)

        post forms_path, params: { target_audience: "Docentes", template_id: "1" }

        expect(response).to redirect_to(forms_path)
      end
    end

    context "Cenário Triste: Tentativa de criar sem selecionar público" do
      it "exibe erro e não envia" do
        post forms_path, params: { target_audience: "" }

        expect(response).to redirect_to(new_form_path)
        expect(flash[:alert]).to eq("Selecione o público-alvo da avaliação")
      end
    end
  end
end
