require 'rails_helper'

RSpec.describe SigaaImportService do
  def create_json_file(filename, content)
    path = Rails.root.join("spec/fixtures/files/#{filename}")
    FileUtils.mkdir_p(File.dirname(path))
    File.write(path, content.to_json)
    path.to_s
  end

  after(:all) do
    FileUtils.rm_rf(Rails.root.join("spec/fixtures/files"))
  end

  describe "#call" do
    context "Validações de Arquivo" do
      it "erro quando o arquivo não é um JSON válido" do
        path = Rails.root.join("spec/fixtures/files/invalid.json")
        File.write(path, "{ isso nao eh json }")

        service = SigaaImportService.new(path.to_s)

        expect { service.call }.to raise_error(SigaaImportService::InvalidFileError, /não é um JSON válido/)
      end

      it "erro quando o JSON não é uma lista (Array)" do
        path = create_json_file("not_array.json", { objeto: "unico" })
        service = SigaaImportService.new(path)

        expect { service.call }.to raise_error(SigaaImportService::InvalidFileError, /deve ser uma lista/)
      end

      it "erro quando falta chave obrigatória na Turma" do
        data = [ { "class" => { "semester" => "2025.1" }, "name" => "Matematica" } ]
        path = create_json_file("missing_keys.json", data)
        service = SigaaImportService.new(path)

        expect { service.call }.to raise_error(SigaaImportService::InvalidFileError, /campo obrigatório 'code' está ausente/)
      end
    end

    context "Importação de Turmas" do
      let(:turma_json) do
        [
          {
            "code" => "CIC001",
            "name" => "Engenharia de Software",
            "class" => { "classCode" => "A", "semester" => "2025.1", "time" => "35T23" }
          }
        ]
      end

      it "cria uma nova turma com sucesso" do
        path = create_json_file("turma_ok.json", turma_json)
        service = SigaaImportService.new(path)

        expect { service.call }.to change(Turma, :count).by(1)

        turma = Turma.last
        expect(turma.nome).to eq("Engenharia de Software (CIC001 - A)")
        expect(turma.semestre).to eq("2025.1")
      end
    end

    context "Importação de Membros (Alunos e Professores)" do
      let!(:turma) { create(:turma, nome: "Cálculo 1 (MAT001 - B)", semestre: "2025.1") }

      let(:membros_json) do
        [
          {
            "code" => "MAT001",
            "classCode" => "B",
            "semester" => "2025.1",
            "docente" => {
              "nome" => "Professor Teste",
              "usuario" => "prof123",
              "email" => "prof@teste.com",
              "ocupacao" => "Docente",
              "formacao" => "Doutor",
              "departamento" => "CIC"
            },
            "dicente" => [
              {
                "nome" => "Aluno Teste",
                "matricula" => "2025001",
                "email" => "aluno@teste.com",
                "curso" => "Engenharia",
                "ocupacao" => "Discente",
                "formacao" => "Ensino Médio"
              }
            ]
          }
        ]
      end

      it "cria usuários e vínculos corretamente" do
        path = create_json_file("membros_ok.json", membros_json)
        service = SigaaImportService.new(path)

        expect { service.call }.to change(Usuario, :count).by(2)
                               .and change(Vinculo, :count).by(2)

        aluno = Usuario.find_by(matricula: "2025001")
        prof = Usuario.find_by(matricula: "prof123")

        expect(aluno.profile).to eq("Aluno")
        expect(prof.profile).to eq("Professor")
        expect(aluno.turmas).to include(turma)
      end
    end
  end
end
