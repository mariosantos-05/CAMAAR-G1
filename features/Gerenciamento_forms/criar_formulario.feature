# language: pt

Funcionalidade: Criar formulário de avaliação
  Como Administrador
  Quero criar um formulário baseado em um template
  Para avaliar o desempenho das turmas no semestre atual

  Contexto:
    Dado que estou logado como Administrador
    E que existe um template chamado "Avaliação Semestral"
    E que existem turmas ativas cadastradas

  Cenário: Criar formulário de avaliação para turmas selecionadas
    Quando eu seleciono o template "Avaliação Semestral"
    E eu seleciono as turmas "Turma A", "Turma B" e "Turma C"
    E eu clico em "Criar Formulário"
    Então formulários devem ser criados para as turmas selecionadas
    E devo ver a mensagem "Formulários criados com sucesso!"

  Cenário: Tentativa de criação sem selecionar turmas
    Quando eu seleciono o template "Avaliação Semestral"
    E eu clico em "Criar Formulário"
    Então nenhum formulário deve ser criado
    E devo ver a mensagem de erro "Selecione um template e pelo menos uma turma."

  Cenário: Tentativa de criação sem selecionar template
    Quando eu seleciono as turmas "Turma A" e "Turma B"
    E eu clico em "Criar Formulário"
    Então nenhum formulário deve ser criado
    E devo ver a mensagem de erro "Selecione um template e pelo menos uma turma."
