# frozen_string_literal: true

Dado("que estou logado como Administrador") do
  @admin = create(:admin)

  visit login_path

  fill_in "login", with: @admin.email
  fill_in "password", with: "Teste@1234"

  click_button "Entrar"
end

Dado("que estou na tela de criação de formulário") do
  visit admin_management_path
  click_link "Criar Formulário"

  # Garante que o modal foi carregado
  expect(page).to have_selector("select#template_id")
end

Dado("que existe um template chamado {string}") do |titulo|
  @template = create(
    :template,
    titulo: titulo,
    criado_por: @admin
  )
end

Dado("que existem turmas ativas cadastradas") do
  create(:turma, nome: "Turma A")
  create(:turma, nome: "Turma B")
  create(:turma, nome: "Turma C")
end

Quando("eu seleciono o template {string}") do |titulo|
  select titulo, from: "template_id"
end

Quando("eu seleciono as turmas {string}, {string} e {string}") do |t1, t2, t3|
  [ t1, t2, t3 ].each do |nome|
    turma = Turma.find_by!(nome: nome)
    check("turma_ids[]", option: turma.id)
  end
end

Quando("eu seleciono as turmas {string} e {string}") do |t1, t2|
  [ t1, t2 ].each do |nome|
    turma = Turma.find_by!(nome: nome)
    check("turma_ids[]", option: turma.id)
  end
end

Quando("eu envio o formulário") do
  click_button "Enviar"
end

Então("formulários devem ser criados para as turmas selecionadas") do
  expect(Form.count).to be > 0
end

Então("nenhum formulário deve ser criado") do
  expect(Form.count).to eq(0)
end

Então("devo ver a mensagem {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end

Então("devo ver a mensagem de erro {string}") do |mensagem|
  expect(page).to have_content(mensagem)
end
