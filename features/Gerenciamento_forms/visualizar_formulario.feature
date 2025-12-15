# language: pt

Funcionalidade: Visualização de formulários para responder
  Como Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  Para poder escolher qual irei responder

  Cenário: Visualizar formulários não respondidos para turmas matriculadas
    Dado que eu estou logado como Participante
    E que eu estou matriculado nas turmas "Turma A" e "Turma B"
    E que existem formulários não respondidos para essas turmas
    Quando eu acesso a seção de formulários disponíveis
    Então eu devo ver os formulários não respondidos das turmas "Turma A" e "Turma B"
    E eu devo ver a indicação de que existem 2 formulários pendentes

  Cenário: Nenhum formulário pendente
    Dado que eu estou logado como Participante
    E que eu estou matriculado nas turmas "Turma A" e "Turma B"
    E que não existem formulários pendentes
    Quando eu acesso a seção de formulários disponíveis
    Então eu devo ver a indicação de que não existem formulários pendentes
