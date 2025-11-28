# language: pt

Funcionalidade: Visualização e Download de Resultados de Avaliação
  Como um administrador
  Eu quero baixar um arquivo CSV contendo os resultados de um formulário
  A fim de avaliar o desempenho das turmas

  Contexto:
    Dado que eu estou logado como "admin@sistema.com"

  Cenário: Admin baixa CSV de uma turma com respostas
    Dado que existe uma turma "BANCOS DE DADOS (CIC0097) - Prof. Joao" com 5 alunos
    E eu estou na página "Resultados"
    Quando eu clico no botão "Baixar CSV" da turma "BANCOS DE DADOS (CIC0097) - Prof. Joao"
    Então o download do arquivo deve ser iniciado
    E o nome do arquivo deve conter "resultados" e "CIC0097"
    
  Cenário: Admin tenta ver resultados de uma turma sem respostas
    Dado que existe uma turma "ENGENHARIA DE SOFTWARE (CIC0105) - Prof. Genaina" com 0 alunos
    E eu estou na página "Resultados"
    Quando eu clico no botão "Baixar CSV" da turma "ENGENHARIA DE SOFTWARE (CIC0105) - Prof. Genaina"
    Então eu devo ver a mensagem "Este formulário ainda não possui respostas"
    E a página não deve fazer download

  Cenário: Professor (não-admin) tenta acessar a página de resultados diretamente pela URL
    Dado que eu estou logado como "professor@sistema.com"
    E o meu perfil é "Professor"
    Quando eu tento acessar a URL "/resultados" diretamente no meu navegador
    Então eu devo ser redirecionado para a "Dashboard"
    E eu devo ver a mensagem "Acesso negado"