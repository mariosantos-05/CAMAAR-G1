# frozen_string_literal: true

Dado("que eu estou logado como Participante") do
  @usuario = create(:usuario, profile: "Aluno", nome: "Aluno Teste")

  visit login_path
  fill_in "login", with: @usuario.email
  fill_in "password", with: "Teste@1234"
  click_button "Entrar"
end

Dado("que eu estou matriculado na turma {string}") do |nome_turma|
  @turma = create(:turma, nome: nome_turma)

  create(
    :vinculo,
    usuario: @usuario,
    turma: @turma
  )
end

Dado("que existe um formulário de avaliação ativo para a turma {string}") do |nome_turma|
  turma = Turma.find_by!(nome: nome_turma)

  template = create(:template)

  # garante ao menos 1 pergunta
  create(
    :question,
    template: template,
    question_type: "text",
    text: "O que você achou da turma?"
  )

  @form = create(
    :form,
    turma: turma,
    template: template,
    is_active: true
  )
end

Quando("eu acesso o formulário de avaliação da turma {string}") do |_nome|
  visit avaliacoes_path
  click_link "Responder: #{@form.template.titulo}"
end

Quando("eu preencho o formulário com respostas válidas") do
  @form.template.questions.each do |q|
    fill_in "answers[#{q.id}]", with: "Resposta de teste"
  end
end

# 🔹 STEP ESPECÍFICO (SEM AMBIGUIDADE)
Quando("eu envio o formulário de avaliação") do
  click_button "➤"
end

Quando("eu envio o formulário de avaliação sem preencher os campos obrigatórios") do
  click_button "➤"
end

Então("o sistema deve registrar minhas respostas") do
  resposta = Resposta.last

  expect(resposta).not_to be_nil
  expect(resposta.usuario).to eq(@usuario)
  expect(resposta.form).to eq(@form)
  expect(resposta.answers).not_to be_empty
end

Então("as respostas não devem ser registradas") do
  expect(Resposta.count).to eq(0)
end
Então("eu devo ver a mensagem de confirmação do envio do formulário") do
  expect(page).to have_content("Formulário enviado com sucesso!")
end

Então("eu devo ver uma mensagem de erro de campos obrigatórios") do
  expect(page).to have_content("Preencha os campos obrigatórios.")
end
