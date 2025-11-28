Dado('que eu estou logado como {string}') do |email|
    @current_user = Member.create!(email: email, nome: "Admin", ocupacao: "docente", matricula: "000000")
end

Dado('que eu estou na página {string}') do |pagina|
    if pagina == "Importar Dados do SIGAA" || pagina.include?("Importar")
        visit '/importar_sigaa'
    else
        visit '/gerenciamento'
    end
end

Dado('o banco de dados não contém nenhuma disciplina ou aluno') do
    Member.destroy_all
    Turma.destroy_all
    Subject.destroy_all
end

Dado('já existe uma disciplina {string} \({string}\) no sistema') do |nome, codigo|
    Subject.create!(name: nome, code: codigo)
end

Dado('eu tenho um arquivo {string} {string}') do |nome_arquivo, _descricao|
    @nome_arquivo = nome_arquivo
end

Dado('eu tenho um arquivo {string}') do |nome_arquivo|
    @nome_arquivo = nome_arquivo
end

Quando('eu seleciono o arquivo {string} para {string}') do |nome_arquivo, _campo|
    path = Rails.root.join('spec/fixtures/files', nome_arquivo)
    attach_file('file', path)
end

Quando('eu seleciono o arquivo {string}') do |nome_arquivo|
    path = Rails.root.join('spec/fixtures/files', nome_arquivo)
    attach_file('file', path)
end

Quando('eu clico no botão {string}') do |texto_botao|
    click_button texto_botao
end

Quando('importo-o ao sistema') do
    click_button "Enviar Arquivo"
end

Então('eu devo ser redirecionado para a {string}') do |pagina|
    expect(current_path).to eq(admin_management_path)
end

Então('eu devo ver a mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
end

Então('eu devo continuar na página {string}') do |_pagina|
    expect(current_path).to eq(import_sigaa_path)
end

Então('eu devo ver a mensagem de erro {string}') do |mensagem|
    expect(page).to have_content(mensagem)
end

Então('a disciplina {string} \({string}\) deve existir no sistema') do |nome, codigo|
    subject = Subject.find_by(code: codigo)
    expect(subject).to be_present
    expect(subject.name).to eq(nome)
end

Então('o aluno {string} \({int}\) deve existir no sistema') do |nome, matricula|
    member = Member.find_by(matricula: matricula.to_s)
    expect(member).to be_present
    expect(member.nome).to eq(nome)
end

Então('deve haver apenas {int} aluno com a matrícula {string} no sistema') do |quantidade, matricula|
    expect(Member.where(matricula: matricula).count).to eq(quantidade)
end

Então(/^o aluno "([^"]*)" \(([^)]*)\) não deve existir no sistema$/) do |nome, matricula|
    member = Member.find_by(matricula: matricula.to_s)
    expect(member).to be_nil
end