Dado('que eu estou logado como {string}') do |email|
    @current_user = Usuario.create!(
        email: email, 
        nome: "Administrador", 
        matricula: "000000",
        profile: "Admin", 
        status: true
    )
end

Dado('que eu estou na página {string}') do |pagina|
    if pagina.include?("Importar")
        visit '/importar_sigaa'
    else
        visit '/gerenciamento'
    end
end

Dado('o banco de dados não contém nenhuma disciplina ou aluno') do
    Vinculo.destroy_all
    Usuario.destroy_all
    Turma.destroy_all
end

Dado('eu tenho um arquivo {string}') do |nome_arquivo|
    @nome_arquivo = nome_arquivo
end

Dado('já existe uma disciplina {string} \({string}\) no sistema') do |nome, codigo|
    nome_completo = "#{nome} (#{codigo} - TA)"
    Turma.create!(nome: nome_completo, semestre: "2021.2", is_active: true)
end

Quando('eu seleciono o arquivo {string}') do |nome_arquivo|
    path = Rails.root.join('spec/fixtures/files', nome_arquivo)
    attach_file('file', path)
end

Quando('eu clico no botão {string}') do |texto_botao|
    click_button texto_botao
end

Então('eu devo ver a mensagem {string}') do |mensagem|
    expect(page).to have_content(mensagem)
end

Então(/^a disciplina "([^"]*)" \(([^)]*)\) deve existir no sistema$/) do |nome, codigo|
    codigo_limpo = codigo.gsub('"', '')
    
    turma = Turma.where("nome LIKE ?", "%#{nome}%").first
    
    expect(turma).to be_present, "A disciplina '#{nome}' não foi encontrada na tabela Turmas."
    
    expect(turma.nome).to include(codigo_limpo)
end

Então(/^o aluno "([^"]*)" \(([^)]*)\) deve existir no sistema$/) do |nome, matricula|
    matricula_limpa = matricula.to_s.gsub('"', '')
    
    usuario = Usuario.find_by(matricula: matricula_limpa)
    
    expect(usuario).to be_present, "O aluno '#{nome}' (Matrícula: #{matricula_limpa}) não foi encontrado."
    expect(usuario.nome).to eq(nome)
    expect(usuario.profile).to eq('Aluno')
end

Então(/^o aluno "([^"]*)" \(([^)]*)\) não deve existir no sistema$/) do |nome, matricula|
    matricula_limpa = matricula.to_s.gsub('"', '')
    
    usuario = Usuario.find_by(matricula: matricula_limpa)
    expect(usuario).to be_nil
end

Então('eu devo continuar na página {string}') do |nome_pagina|
    if nome_pagina.include?("Importar")
        expect(current_path).to eq(import_sigaa_path)
    else
        expect(current_path).to eq(admin_management_path)
    end
end