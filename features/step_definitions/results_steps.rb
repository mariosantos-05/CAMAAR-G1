# features/step_definitions/results_steps.rb

Dado('que existe uma turma {string} com {int} alunos') do |nome_turma, qtd_alunos|
  # Cria a turma
  turma = Turma.create!(nome: nome_turma, semestre: "2021.2", is_active: true)
  
  # Cria os alunos (Vínculos)
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
  # Acha o bloco da turma pelo texto do título
  turma_element = find('h4', text: nome_turma).find(:xpath, '..')
  
  # Clica no link dentro desse bloco
  within(turma_element) do
    click_link "Baixar CSV"
  end
end

Então('o download do arquivo deve ser iniciado') do
  # Verifica se o cabeçalho da resposta indica um anexo CSV
  expect(page.response_headers['Content-Type']).to include('text/csv')
end

Então('o nome do arquivo deve conter {string} e {string}') do |parte1, parte2|
  disposition = page.response_headers['Content-Disposition']
  expect(disposition).to include(parte1)
  expect(disposition).to include(parte2)
end

Então('a página não deve fazer download') do
  # Se não fez download, o content-type continua sendo HTML
  expect(page.response_headers['Content-Type']).to include('text/html')
end

# --- Lógica de Acesso Negado ---

Dado('o meu perfil é {string}') do |perfil|
  # Cria um objeto falso (Mock) que responde a .profile
  user_mock = double("User", profile: perfil)

  # Injeta esse objeto falso no controller APENAS para este cenário
  allow_any_instance_of(AdminsController).to receive(:current_user).and_return(user_mock)
end

Quando('eu tento acessar a URL {string} diretamente no meu navegador') do |url|
  visit url
end

Então('eu devo ser redirecionado para a {string}') do |pagina|
  path = pagina == "Dashboard" ? '/gerenciamento' : pagina
  expect(current_path).to eq(path)
end