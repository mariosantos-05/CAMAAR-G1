# frozen_string_literal: true

# ===============================
# DADOS INICIAIS (Setup)
# ===============================

Dado("que eu estou logado como Administrador") do
  @usuario = create(
    :usuario,
    profile: "Admin",
    nome: "Admin Teste",
    password: "Teste@1234",
    departamento_id: 1 # garante prefixo CIC no controller
  )

  visit login_path
  fill_in "login", with: @usuario.email
  fill_in "password", with: "Teste@1234"
  click_button "Entrar"
end

Dado("que existem formulários criados para as turmas {string} e {string}") do |turma1, turma2|
  [turma1, turma2].each do |nome|
    turma = create(:turma, nome: "#{nome} (CIC)")
    template = create(:template)
    create(:form, turma: turma, template: template, is_active: true)
  end
end

Dado("que existe um formulário criado para a turma {string}") do |nome_turma|
  turma = create(:turma, nome: "#{nome_turma} (CIC)")
  template = create(:template)

  question = create(
    :question,
    template: template,
    question_type: "text",
    text: "Pergunta Teste"
  )

  form = create(:form, turma: turma, template: template, is_active: true)

  usuario = create(:usuario)

  create(
    :resposta,
    form: form,
    usuario: usuario,
    answers: { question.id.to_s => "Resposta Teste" }
  )
end

# ===============================
# AÇÕES DO USUÁRIO
# ===============================

Quando("eu acesso a seção de formulários criados") do
  visit admin_results_path
end

Quando("eu acesso a página de respostas da turma {string}") do |turma|
  t = Turma.find_by!("nome LIKE ?", "#{turma}%")
  visit admin_turma_respostas_path(t.id)
end

# ===============================
# VALIDAÇÕES
# ===============================

Então("eu devo ver os formulários criados para todas as turmas") do
  expect(page).to have_content("Turma A")
  expect(page).to have_content("Turma B")
end

Então("eu devo ver a contagem de respostas para cada turma") do
  ["Turma A", "Turma B"].each do |turma|
    card = find(:xpath, "//h4[contains(text(),'#{turma}')]/parent::div")
    expect(card).to have_content("Respostas:")
  end
end

Então("eu devo ver links para {string} e {string} para cada turma") do |csv, respostas|
  ["Turma A", "Turma B"].each do |turma|
    card = find(:xpath, "//h4[contains(text(),'#{turma}')]/parent::div")
    expect(card).to have_link(csv)
    expect(card).to have_link(respostas)
  end
end

Então("eu devo visualizar as perguntas do formulário") do
  expect(page).to have_content("Pergunta Teste")
end

Então("eu devo visualizar as respostas registradas") do
  expect(page).to have_content("Resposta Teste")
end

Então("eu devo visualizar as estatísticas do formulário") do
  pending "Estatísticas ainda não implementadas na view"
end
