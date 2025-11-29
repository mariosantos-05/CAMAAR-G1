# language: pt

Funcionalidade: Atualização da base de dados por importação de JSON do SIGAA
    Como um administrador do sistema
    Eu quero fazer o upload de arquivos JSON para atualizar turmas e alunos
    A fim de manter os dados sincronizados e corrigir informações (como e-mails).

    Contexto:
        Dado que eu estou logado como "admin@sistema.com"
        E que eu estou na página "Importar Dados do SIGAA"

    Cenário: Admin importa JSON de um novo semestre (Funcionamento Padrão)
        Dado o banco de dados não contém nenhuma disciplina ou aluno
        E eu tenho um arquivo "disciplinas_2021.2.json"
        E eu tenho um arquivo "turmas_2021.2.json"
        Quando eu seleciono o arquivo "disciplinas_2021.2.json"
        E eu clico no botão "Enviar Arquivo"
        E que eu estou na página "Importar Dados do SIGAA"
        E eu seleciono o arquivo "turmas_2021.2.json"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo ver a mensagem "Dados importados com sucesso!"
        E a disciplina "BANCOS DE DADOS" ("CIC0097") deve existir no sistema
        E o aluno "Ana Clara Jordao Perna" ("190084006") deve existir no sistema

    Cenário: Admin importa JSON que atualiza o email de um aluno
        Dado já existe uma disciplina "BANCOS DE DADOS" ("CIC0097") no sistema
        Dado existe uma aluna "Ana Clara Jordao Perna" com matrícula "190084006" e email "email.antigo@gmail.com"
        E eu tenho um arquivo "turmas_correcao.json"
        Quando eu seleciono o arquivo "turmas_correcao.json"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo ver a mensagem "Dados importados com sucesso!"
        E a aluna com matrícula "190084006" deve ter o email "ana.clara@aluno.unb.br"
        # Verifica que não duplicou
        E deve haver apenas 1 aluno com a matrícula "190084006" no sistema

    Cenário: Admin tenta importar um arquivo que não é JSON
        Dado eu tenho um arquivo "documento.csv"
        Quando eu seleciono o arquivo "documento.csv"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo continuar na página "Importar Dados do SIGAA"
        E eu devo ver a mensagem "O arquivo não é um JSON válido"

    Cenário: Admin importa JSON de turma com chave "matricula" faltando
        Dado eu tenho um arquivo "turmas_sem_matricula.json"
        Quando eu seleciono o arquivo "turmas_sem_matricula.json"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo continuar na página "Importar Dados do SIGAA"
        E eu devo ver a mensagem "O campo obrigatório 'matricula' está ausente ou vazio"

    Cenário: Admin importa JSON com sintaxe quebrada
        Dado eu tenho um arquivo "json_errado.json"
        Quando eu seleciono o arquivo "json_errado.json"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo continuar na página "Importar Dados do SIGAA"
        E eu devo ver a mensagem "O arquivo não é um JSON válido"

    Cenário: Admin importa JSON com tipo de dado inválido para matrícula
        Dado eu tenho um arquivo "turmas_tipo_errado.json"
        Quando eu seleciono o arquivo "turmas_tipo_errado.json"
        E eu clico no botão "Enviar Arquivo"
        Então eu devo continuar na página "Importar Dados do SIGAA"
        E eu devo ver a mensagem "A matrícula deve conter apenas números"