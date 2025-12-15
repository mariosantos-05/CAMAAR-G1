# language: pt

Funcionalidade: Responder formulário
  Como Participante de uma turma
  Quero responder o questionário sobre a turma em que estou matriculado
  Para submeter minha avaliação da turma

  Contexto:
    Dado que eu estou logado como Participante
    E que eu estou matriculado na turma "Turma A"
    E que existe um formulário de avaliação ativo para a turma "Turma A"

  Cenário: Responder formulário de avaliação com sucesso
    Quando eu acesso o formulário de avaliação da turma "Turma A"
    E eu preencho o formulário com respostas válidas
    E eu envio o formulário de avaliação
    Então o sistema deve registrar minhas respostas
    E eu devo ver a mensagem de confirmação do envio do formulário

  Cenário: Tentativa de envio sem preencher campos obrigatórios
    Quando eu acesso o formulário de avaliação da turma "Turma A"
    E eu envio o formulário de avaliação sem preencher os campos obrigatórios
    Então eu devo ver uma mensagem de erro de campos obrigatórios
    E as respostas não devem ser registradas
