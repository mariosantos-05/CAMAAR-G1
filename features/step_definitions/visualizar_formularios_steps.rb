Dado("que eu estou matriculado nas turmas {string} e {string}") do |t1, t2|
  [ t1, t2 ].each do |nome_turma|
    turma = create(:turma, nome: nome_turma)
    create(:vinculo, usuario: @usuario, turma: turma)
  end
end

Dado("que existem formulários não respondidos para essas turmas") do
  @usuario.vinculos.each do |vinculo|
    template = create(:template, titulo: "Template #{vinculo.turma.nome}")
    create(:question, template: template, question_type: "text", text: "Pergunta Teste")
    create(:form, turma: vinculo.turma, template: template, is_active: true)
  end
end

Dado("que não existem formulários pendentes") do
  # Não cria nenhum form
end

Quando("eu acesso a seção de formulários disponíveis") do
  visit avaliacoes_path
end

Então("eu devo ver os formulários não respondidos das turmas {string} e {string}") do |t1, t2|
  expect(page).to have_content(t1)
  expect(page).to have_content(t2)

  @usuario.vinculos.each do |vinculo|
    vinculo.turma.forms.each do |form|
      expect(page).to have_link("Responder: #{form.template.titulo}")
    end
  end
end

Então("eu devo ver a indicação de que existem {int} formulários pendentes") do |quantidade|
  total_links = page.all('a', text: /^Responder:/).size
  expect(total_links).to eq(quantidade)
end

Então("eu devo ver a indicação de que não existem formulários pendentes") do
  total_links = page.all('a', text: /^Responder:/).size
  expect(total_links).to eq(0)
end
