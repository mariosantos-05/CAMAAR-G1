Dado("que estou logado como Administrador") do
  @admin = Usuario.create!(
    nome: "Admin",
    email: "admin@test.com",
    password: "123456",
    profile: "Admin"
  )

  login_as(@admin, scope: :usuario)
end

Dado("que existe um template chamado {string}") do |titulo|
  @template = Template.create!(
    titulo: titulo,
    criado_por: @admin,
    questions_attributes: [
      { text: "Como você avalia a disciplina?", question_type: "radio", options: ["Boa", "Regular", "Ruim"] }
    ]
  )
end

Dado("que existem turmas ativas cadastradas") do
  @turmas = [
    Turma.create!(nome: "Turma A", semestre: "2024.1", is_active: true),
    Turma.create!(nome: "Turma B", semestre: "2024.1", is_active: true),
    Turma.create!(nome: "Turma C", semestre: "2024.1", is_active: true)
  ]
end

Quando("eu seleciono o template {string}") do |titulo|
  visit admin_management_path
  select titulo, from: "template_id"
end

Quando("eu seleciono as turmas {string}, {string} e {string}") do |t1, t2, t3|
  [t1, t2, t3].each do |nome|
    turma = Turma.find_by(nome: nome)
    check("turma_ids[]", option: turma.id)
  end
end

Quando("eu seleciono as turmas {string} e {string}") do |t1, t2|
  [t1, t2].each do |nome|
    turma = Turma.find_by(nome: nome)
    check("turma_ids[]", option: turma.id)
  end
end

Quando("eu clico em {string}") do |botao|
  click_button botao
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
