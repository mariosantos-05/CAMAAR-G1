FileUtils.mkdir_p('spec/fixtures/files')

Before do
    File.write('spec/fixtures/files/disciplinas_2021.2.json', [
        {
        "code" => "CIC0097",
        "name" => "BANCOS DE DADOS",
        "class" => { "classCode" => "A", "semester" => "2021.2", "time" => "35T23" }
        }
    ].to_json)

    File.write('spec/fixtures/files/turmas_2021.2.json', [
        {
        "code" => "CIC0097",
        "classCode" => "A",
        "semester" => "2021.2",
        "docente" => {
            "nome" => "Professor Teste",
            "usuario" => "101010",
            "email" => "prof@unb.br",
            "ocupacao" => "Docente",
            "formacao" => "Doutorado",
            "departamento" => "CIC"
        },
        "dicente" => [
            {
            "nome" => "Ana Clara Jordao Perna",
            "matricula" => "190084006",
            "curso" => "Ciência da Computação",
            "email" => "email.antigo@gmail.com",
            "ocupacao" => "Discente",
            "formacao" => "Graduação"
            }
        ]
        }
    ].to_json)

    File.write('spec/fixtures/files/turmas_correcao.json', [
        {
        "code" => "CIC0097",
        "classCode" => "A",
        "semester" => "2021.2",
        "docente" => { "nome" => "Prof", "usuario" => "1010", "email" => "p@u.br", "ocupacao" => "D", "formacao" => "D", "departamento" => "CIC" },
        "dicente" => [
            {
            "nome" => "Ana Clara Jordao Perna",
            "matricula" => "190084006",
            "curso" => "Ciência da Computação",
            "email" => "ana.clara@aluno.unb.br", # Email novo
            "ocupacao" => "Discente",
            "formacao" => "Graduação"
            }
        ]
        }
    ].to_json)

    File.write('spec/fixtures/files/documento.csv', "coluna1,coluna2\nval1,val2")

    File.write('spec/fixtures/files/turmas_sem_matricula.json', [
        {
        "code" => "CIC0097", "classCode" => "A", "semester" => "2021.2",
        "dicente" => [{ "nome" => "Sem Matricula", "email" => "teste@teste.com" }]
        }
    ].to_json)

    File.write('spec/fixtures/files/json_errado.json', "{ ouça o novo álbum da TAEYEON! }")

    File.write('spec/fixtures/files/turmas_tipo_errado.json', [
        {
        "code" => "CIC0097", "classCode" => "A", "semester" => "2021.2",
        "dicente" => [{ 
            "nome" => "Errado", 
            "matricula" => "TEXTO_EM_VEZ_DE_NUMERO", 
            "email" => "a@a.com",
            "curso" => "Ciência da Computação", 
            "ocupacao" => "Discente",           
            "formacao" => "Graduação"           
        }]
        }
    ].to_json)
end

Dado('que eu estou logado como {string}') do |email|
    matricula_unica = email.include?('admin') ? "000000" : email.hash.abs.to_s[0..8]
    
    perfil = email.include?('admin') ? 'Admin' : 'Professor'

    @user = Usuario.find_or_create_by!(email: email) do |u|
        u.nome = perfil
        u.matricula = matricula_unica
        u.profile = perfil
        u.departamento_id = 1
        u.status = true
        u.password = "Teste@1234"
    end

    visit root_path
    fill_in 'Email', with: email
    fill_in 'Senha', with: 'Teste@1234'
    click_button 'Entrar'
    
    if page.has_content?("Entrar") || page.has_field?("Senha")
        puts "HTML da página atual: #{page.html}"
        raise "O Login falhou para #{email}!"
    end
end

Dado('o banco de dados não contém nenhuma disciplina ou aluno') do
    Vinculo.destroy_all
    Turma.destroy_all
    
    if @user
        Usuario.where.not(id: @user.id).destroy_all
    else
        Usuario.where.not(profile: 'Admin').destroy_all
    end
end

Dado('eu tenho um arquivo {string}') do |nome_arquivo|
    @nome_arquivo = nome_arquivo
end

Dado('já existe uma disciplina {string} \({string}\) no sistema') do |nome, codigo|
    nome_completo = "#{nome} (#{codigo} - TA)"
    Turma.create!(nome: nome_completo, semestre: "2021.2", is_active: true)
end

Dado('que eu estou na página {string}') do |nome_pagina|
    case nome_pagina
    when "Importar Dados do SIGAA"
        visit import_sigaa_path
        
    when "Gerenciamento", "Dashboard"
        visit admin_management_path
        
    when "Resultados"
        visit admin_results_path
        
    else
        raise "Erro: A página '#{nome_pagina}' não foi mapeada no step definition."
    end
end

Quando('eu seleciono o arquivo {string}') do |nome_arquivo|
    caminho = Rails.root.join('spec/fixtures/files', nome_arquivo)
    FileUtils.mkdir_p(File.dirname(caminho))

    if nome_arquivo == 'turmas_tipo_errado.json'
        conteudo_tipo_errado = [
            {
            "code" => "CIC0097", "classCode" => "A", "semester" => "2021.2",
            "dicente" => [{ 
                "nome" => "Errado", 
                "matricula" => "KIM TAEYEON",
                "email" => "a@a.com",
                "curso" => "Ciência da Computação", 
                "ocupacao" => "Discente",           
                "formacao" => "Graduação"           
            }]
            }
        ].to_json
        File.write(caminho, conteudo_tipo_errado)

    elsif nome_arquivo == 'turmas_sem_matricula.json'
        conteudo_correto = [
            {
            "code" => "FALHA01", "classCode" => "A", "semester" => "2021.2",
            "dicente" => [{ "nome" => "TAEYEON", "email" => "teste@teste.com", "curso" => "CC" }]
            }
        ].to_json
        File.write(caminho, conteudo_correto)
    
    elsif nome_arquivo.match?(/csv|errado|txt|pdf|sintaxe|json_errado/)
        File.write(caminho, "json inválido")

    elsif nome_arquivo.match?(/objeto|hash|unico|estrutura|nao_lista/)
        File.write(caminho, { "TAEYEON" => "NOVO ÁLBUM" }.to_json)
    
    elsif nome_arquivo.match?(/aleatorio|desconhecido|random/)
        conteudo_aleatorio = [{ "VOCALISTA" => "TAEYEON", "ARTISTA" => 8000 }] 
        File.write(caminho, conteudo_aleatorio.to_json)

    elsif !File.exist?(caminho)
        File.write(caminho, [].to_json)
    end

    find('input[type="file"]', visible: :all).attach_file(caminho)
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

Dado('existe uma aluna {string} com matrícula {string} e email {string}') do |nome, matricula, email|
    Usuario.create!(
        nome: nome,
        matricula: matricula,
        email: email,
        profile: "Aluno",
        status: true,
        password: "Teste@1234",
        departamento_id: 1
    )
end

Então('a aluna com matrícula {string} deve ter o email {string} no banco de dados') do |matricula, novo_email|
    usuario = Usuario.find_by(matricula: matricula)
    expect(usuario.email).to eq(novo_email)
end

Então('deve haver apenas {int} aluno com a matrícula {string} no sistema') do |quantidade, matricula|
    expect(Usuario.where(matricula: matricula).count).to eq(quantidade)
end

Então('a aluna com matrícula {string} deve ter o email {string}') do |matricula, novo_email|
    usuario = Usuario.find_by(matricula: matricula)

    expect(usuario).to be_present, "Usuário com matrícula #{matricula} não encontrado."
    expect(usuario.email).to eq(novo_email)
end