# language: pt
Funcionalidade: Alimentação inicial da base de dados com JSON do SIGAA
    Como um administrador
    Eu quero importar arquivos JSON (Turmas e Alunos)
    A fim de alimentar a base de dados do sistema com segurança e integridade.

    Contexto:
        Dado que eu estou logado como "admin@sistema.com"
        E que eu estou na página "Importar Dados do SIGAA"

    Cenário: Admin importa Turmas e depois Alunos em um sistema vazio
        Dado o banco de dados não contém nenhuma disciplina ou aluno
        E eu tenho um arquivo "disciplinas_2021.2.json"
        E eu tenho um arquivo "turmas_2021.2.json"
        Quando eu seleciono o arquivo "disciplinas_2021.2.json"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo ver a mensagem "Dados importados com sucesso!"
        E a disciplina "BANCOS DE DADOS" ("CIC0097") deve existir no sistema
        E que eu estou na página "Importar Dados do SIGAA"
        Quando eu seleciono o arquivo "turmas_2021.2.json"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo ver a mensagem "Dados importados com sucesso!"
        E o aluno "Ana Clara Jordao Perna" (190084006) deve existir no sistema

    Cenário: Admin reenvia arquivo e o sistema ignora duplicatas
        Dado já existe uma disciplina "BANCOS DE DADOS" ("CIC0097") no sistema
        E eu tenho um arquivo "disciplinas_2021.2.json"
        Quando eu seleciono o arquivo "disciplinas_2021.2.json"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo ver a mensagem "Dados importados com sucesso!"
        # Verifica se não duplicou (continua existindo apenas 1 registro)
        E a disciplina "BANCOS DE DADOS" ("CIC0097") deve existir no sistema

    Cenário: Admin tenta enviar um arquivo que não é JSON (Sintaxe Inválida)
        # Aqui usamos um arquivo de texto renomeado ou pdf
        Dado eu tenho um arquivo "arquivo_texto.txt"
        Quando eu seleciono o arquivo "arquivo_texto.txt"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo ver a mensagem "O arquivo não é um JSON válido"
        E eu devo continuar na página "Importar Dados do SIGAA"

    Cenário: Admin envia JSON com estrutura incorreta (Falta campo obrigatório)
        # Este arquivo tem um aluno sem a chave "matricula"
        Dado eu tenho um arquivo "turmas_sem_matricula.json"
        Quando eu seleciono o arquivo "turmas_sem_matricula.json"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo ver a mensagem "Erro de Validação"
        E eu devo ver a mensagem "O campo obrigatório 'matricula' está ausente ou vazio"
        E o aluno "Aluno Sem Matricula" (0) não deve existir no sistema

    Cenário: Admin envia JSON desconhecido (Nem turma, nem aluno)
        # Um JSON válido, mas com dados aleatórios
        Dado eu tenho um arquivo "json_aleatorio.json"
        Quando eu seleciono o arquivo "json_aleatorio.json"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo ver a mensagem "Erro de Validação"
        E eu devo ver a mensagem "O JSON deve ser uma lista (Array) de objetos"