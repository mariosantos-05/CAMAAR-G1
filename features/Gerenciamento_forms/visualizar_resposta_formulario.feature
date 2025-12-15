# language: pt

Funcionalidade: Visualização de resultados dos formulários
    Eu como Administrador
    Quero visualizar os formulários criados
    A fim de poder gerar um relatório a partir das respostas

  Cenário: Visualizar formulários criados para turmas selecionadas
    Dado que eu estou logado como Administrador
    E que existem formulários criados para as turmas "Turma A" e "Turma B"
    Quando eu acesso a seção de formulários criados
    Então eu devo ver os formulários criados para todas as turmas
    E eu devo ver a contagem de respostas para cada turma
    E eu devo ver links para "Baixar CSV" e "Ver Respostas" para cada turma

  Cenário: Visualizar detalhes de um formulário
    Dado que eu estou logado como Administrador
    E que existe um formulário criado para a turma "Turma A"
    Quando eu acesso a página de respostas da turma "Turma A"
    Então eu devo visualizar as perguntas do formulário
    E eu devo visualizar as respostas registradas
    E eu devo visualizar as estatísticas do formulário
