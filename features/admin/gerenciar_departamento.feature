# language: pt

Funcionalidade: Restrição de visualização de turmas por departamento
    Como um Administrador
    Quero gerenciar somente as turmas do departamento ao qual eu pertenço
    A fim de focar a avaliação no meu contexto e não acessar dados indevidos.

    Contexto:
        Dado que existe um departamento "CIC" (ID: 1) e um departamento "MAT" (ID: 2)
        E que existe uma turma "BANCOS DE DADOS (CIC0097 - TA)" do departamento "CIC"
        E que existe uma turma "CÁLCULO 1 (MAT0025 - A)" do departamento "MAT"

    Cenário: Admin do CIC vê apenas turmas do CIC
        Dado que eu estou logado como "admin.cic@unb.br" com perfil "Admin" e departamento "CIC" (ID: 1)
        E eu navego para a página "Resultados"
        Então eu devo ver a turma "BANCOS DE DADOS (CIC0097 - TA)"
        E eu não devo ver a turma "CÁLCULO 1 (MAT0025 - A)"

    Cenário: Admin da MAT vê apenas turmas da MAT
        Dado que eu estou logado como "admin.mat@unb.br" com perfil "Admin" e departamento "MAT" (ID: 2)
        E eu navego para a página "Resultados"
        Então eu não devo ver a turma "BANCOS DE DADOS (CIC0097 - TA)"
        E eu devo ver a turma "CÁLCULO 1 (MAT0025 - A)"