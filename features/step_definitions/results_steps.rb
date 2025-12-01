Dado('que existe uma turma {string} com {int} alunos') do |nome_turma, qtd_alunos|
  turma = Turma.create!(nome: nome_turma, semestre: "2021.2", is_active: true)
  
  qtd_alunos.times do |i|
    u = Usuario.create!(
      nome: "Aluno #{i}", 
      email: "aluno#{i}@teste.com", 
      matricula: "100#{i}", 
      profile: "Aluno", 
      status: true
    )
    Vinculo.create!(usuario: u, turma: turma, papel_turma: 0)
  end
end

Dado('eu estou na página {string}') do |pagina|
  if pagina == "Resultados"
    visit '/resultados'
  else
    visit '/gerenciamento'
  end
end

Quando('eu clico no botão "Baixar CSV" da turma {string}') do |nome_turma|
  turma_element = find('h4', text: nome_turma).find(:xpath, '..')
  
  within(turma_element) do
    click_link "Baixar CSV"
  end
end

Então('o download do arquivo deve ser iniciado') do
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

Dado('o meu perfil é {string}') do |perfil|
  user_mock = double("User", profile: perfil)

  allow_any_instance_of(AdminsController).to receive(:current_user).and_return(user_mock)
end

Quando('eu tento acessar a URL {string} diretamente no meu navegador') do |url|
  visit url
end

Então('eu devo ser redirecionado para a {string}') do |pagina|
  path = pagina == "Dashboard" ? '/gerenciamento' : pagina
  expect(current_path).to eq(path)
end

Dado('que existe um departamento {string} \(ID: {int}) e um departamento {string} \(ID: {int})') do |d1, id1, d2, id2|
end

Dado('que existe uma turma {string} do departamento {string}') do |nome_turma, departamento|
  Turma.create!(nome: nome_turma, semestre: "2021.2", is_active: true)
end

Dado('que eu estou logado como {string} com perfil {string} e departamento {string} \(ID: {int})') do |email, perfil, _dept_nome, dept_id|

  user_mock = double("User", profile: perfil, departamento_id: dept_id, email: email)
  
  allow_any_instance_of(AdminsController).to receive(:current_user).and_return(user_mock)

  allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_mock)
end

Então('eu devo ver a turma {string}') do |nome_turma|
  expect(page).to have_content(nome_turma)
end

Então('eu não devo ver a turma {string}') do |nome_turma|
  expect(page).not_to have_content(nome_turma)
end

Quando('eu navego para a página {string}') do |nome_pagina|
  case nome_pagina
  when "Resultados"
    visit '/resultados'
  when "Gerenciamento", "Dashboard"
    visit '/gerenciamento'
  when "Importar Dados"
    visit '/importar_sigaa'
  else
    raise "Caminho para a página '#{nome_pagina}' não foi definido nos steps."
  end
end