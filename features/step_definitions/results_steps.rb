# frozen_string_literal: true

# -----------------------------------------------------------------------------
# DADOS (GIVEN)
# -----------------------------------------------------------------------------

Dado('que existe uma turma {string} com {int} alunos') do |nome_turma, qtd_alunos|
  # 1. Busca ou Cria a Turma
  @turma = Turma.find_or_create_by!(nome: nome_turma) do |t|
    t.semestre = "2021.2"
    t.is_active = true
  end
  
  # 2. Garante Admin
  admin = Usuario.find_by(profile: 'Admin') 
  unless admin
     admin = Usuario.create!(
       nome: "Admin Temp", email: "temp@admin.com", matricula: "99999", 
       profile: "Admin", status: true, password: "Teste@1234", departamento_id: 1
     )
  end

  # 3. Garante Template (CORREÇÃO: Bypassing da validação de questões)
  # Usamos find_or_initialize para configurar, e save(validate: false) para pular
  # a regra que exige questões antes de salvar.
  template = Template.find_or_initialize_by(titulo: "Template CSV")
  template.criado_por = admin
  template.target_audience = "Alunos"
  template.save(validate: false) # <--- PULA A VALIDAÇÃO "Deve ter uma questão"
  
  # 4. Garante Pergunta (Agora que o template tem ID, podemos criar a pergunta)
  pergunta = Question.where(template: template, text: "Questão 1").first_or_create!(question_type: "text")

  # 5. Garante o Form
  form = Form.where(turma: @turma, template: template).first_or_create!

  # 6. Garante Alunos e Respostas
  qtd_alunos.times do |i|
    email_aluno = "aluno_csv_#{i}_#{Time.now.to_i}@teste.com"
    matricula_aluno = "CSV#{i}#{Time.now.to_i.to_s[-4..-1]}"

    aluno = Usuario.create!(
      nome: "Aluno #{i}",
      email: email_aluno,
      matricula: matricula_aluno,
      profile: "Aluno",
      status: true,
      password: "Teste@1234",
      departamento_id: 1
    )
    
    # Vincula
    Vinculo.create!(usuario: aluno, turma: @turma, papel_turma: 0)

    # Cria Resposta
    Resposta.create!(
      form: form,
      usuario: aluno,
      answers: { pergunta.id.to_s => "Resposta teste do aluno #{i}" }
    )
  end
end

Dado('que existe uma turma {string} do departamento {string}') do |nome_turma, _nome_dept|
  Turma.find_or_create_by!(nome: nome_turma) do |t|
    t.semestre = "2021.2"
    t.is_active = true
  end
end

Dado('que eu estou logado como {string} com perfil {string} e departamento {string} \(ID: {int})') do |email, perfil, _dept_nome, dept_id|
  @user = Usuario.find_or_create_by!(email: email) do |u|
    u.nome = "Usuário Teste"
    
    u.matricula = "#{dept_id}#{Time.now.to_i.to_s[-5..-1]}#{rand(10..99)}"
    
    u.profile = perfil
    u.departamento_id = dept_id
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

Dado('o meu perfil é {string}') do |perfil|
  email = "teste.#{perfil.downcase}@sistema.com"
  step "que eu estou logado como \"#{email}\" com perfil \"#{perfil}\" e departamento \"Geral\" (ID: 1)"
end

Dado('que existe um departamento {string} \(ID: {int}) e um departamento {string} \(ID: {int})') do |d1, id1, d2, id2|
  # Documentação apenas
end

Dado('eu estou na página {string}') do |pagina|
  step "eu navego para a página \"#{pagina}\""
end

# -----------------------------------------------------------------------------
# AÇÕES (WHEN)
# -----------------------------------------------------------------------------

Quando('eu navego para a página {string}') do |nome_pagina|
  case nome_pagina
  when "Resultados"
    visit admin_results_path
  when "Gerenciamento", "Dashboard"
    visit admin_management_path
  when "Importar Dados"
    visit import_sigaa_path
  else
    raise "Caminho para a página '#{nome_pagina}' não mapeado."
  end
end

Quando('eu clico no botão "Baixar CSV" da turma {string}') do |nome_turma|
  # Localiza a linha da tabela ou div que tem o nome da turma
  turma_element = find('tr, div', text: nome_turma, match: :first)
  
  within(turma_element) do
    # Clica no link de CSV
    find("a[href*='csv']").click
  end
end

Quando('eu tento acessar a URL {string} diretamente no meu navegador') do |url|
  visit url
end

# -----------------------------------------------------------------------------
# VERIFICAÇÕES (THEN)
# -----------------------------------------------------------------------------

Então('o download do arquivo deve ser iniciado') do
  if page.response_headers['Content-Type'].to_s.include?('text/html')
    puts "DEBUG: O sistema retornou HTML em vez de CSV. Conteúdo:"
    puts page.body 
  end

  expect(page.response_headers['Content-Type']).to include('text/csv')
end

Então('o nome do arquivo deve conter {string} e {string}') do |parte1, parte2|
  disposition = page.response_headers['Content-Disposition']
  expect(disposition).to include(parte1)
  expect(disposition).to include(parte2)
end

Então('a página não deve fazer download') do
  expect(page.response_headers['Content-Type']).to include('text/html')
end

Então('eu devo ser redirecionado para a {string}') do |pagina|
  path_esperado = case pagina
                  when "Gerenciamento" then admin_management_path
                  when "Login" then login_path
                  when "Dashboard", "Home", "Página Inicial" then root_path
                  else pagina
                  end
  expect(current_path).to eq(path_esperado)
end

Então('eu devo ver a turma {string}') do |nome_turma|
  expect(page).to have_content(nome_turma)
end

Então('eu não devo ver a turma {string}') do |nome_turma|
  expect(page).not_to have_content(nome_turma)
end