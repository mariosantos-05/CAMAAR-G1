Funcionalidade: Criar template de formulário  

Cenário: Criação de template com dados válidos (Feliz)
    Dado que estou na página de criação de templates
    E preencho o campo "Nome do template" com "Avaliação 2024"
    E adiciono um tipo de questão de múltipla escolha
    E adiciono um tipo de questão discursiva
    Quando clico no botão "Salvar Template"
    Então o sistema deve exibir a mensagem "Template criado com sucesso"
    E o template deve ser salvo no banco de dados

Cenário: Tentativa de criação com título vazio (Triste)
    Dado que estou na página de criação de templates
    E deixo o campo "Título" vazio
    E adiciono tipos de questões válidas
    Quando clico no botão "Salvar Template"
    Então o sistema deve exibir a mensagem de erro "O campo Título é obrigatório"
    E o template não deve ser salvo

Cenário: Tentativa de criação sem questões (Triste)
    Dado que preencho o título corretamente
    E não adiciono nenhum tipo de questão ao template
    Quando clico no botão "Salvar Template"
    Então o sistema deve exibir o erro "O template deve conter pelo menos uma questão"
    E o template não deve ser salvo


Funcionalidade: Visualização dos templates criados 

Cenário: Visualizar lista de templates existentes (Feliz)
    Dado que existem templates salvos no sistema
    Quando eu acesso a página "Templates"
    Então devo ver uma lista contendo todos os templates criados
    E devo ver as opções de "Editar" e "Deletar" para cada template da lista

Cenário: Visualizar lista vazia (Triste)
    Dado que não existe nenhum template salvo no sistema
    Quando eu acesso a página "Templates"
    Então o sistema deve exibir a mensagem "Nenhum template foi criado"
    E a lista de visualização deve estar vazia

    Funcionalidade: Edição e Deleção de Templates

Cenário: Edição de nome de template usado em formulário antigo (Feliz)
    Dado que tenho o template "Avaliação A" associado a um formulário já respondido
    Quando eu edito o nome do template para "Avaliação A - Revisada"
    E clico no botão "Salvar"
    Então o sistema deve atualizar o template para "Avaliação A - Revisada"
    E os formulários antigos criados com o template "Avaliação A" não devem sofrer alteração

Cenário: Deleção de um template existente (Feliz)
    Dado que seleciono um template existente na lista
    Quando clico em "Deletar"
    E aparece um pop-up com o texto "Você tem certeza que deseja deletar este template?"
    E confirmo a ação clicando no botão "Confirmar"
    Então o template deve ser removido da lista de visualização
    E não devo ver ele no gerenciamento de templates

Cenário: Edição com caracteres inválidos no título (Triste)
    Dado que estou na tela de edição de um template
    Quando preencho o campo "Título" com caracteres não permitidos
    Então o sistema deve exibir a mensagem "Formato de título inválido"
    E aparece uma mensagem de texto indicando quais caracteres não são permitidos
    E as alterações não devem ser salvas

    Funcionalidade: Criação de formulário para docentes ou dicentes

Cenário: Enviar formulário para Discentes de uma turma específica (Feliz)
    Dado que estou criando um novo formulário a partir de um template
    Quando seleciono a opção "Discentes" no campo de público-alvo
    E seleciono uma turma válida "Turma A - Engenharia"
    E clico no botão "Enviar"
    Então o formulário deve ser enviado especificamente para os alunos daquela turma

Cenário: Enviar formulário para Docentes (Feliz)
    Dado que estou criando um novo formulário
    Quando seleciono a opção "Docentes" no campo de público-alvo
    Então o formulário deve ser enviado especificamente para os professores
    E o campo de seleção de turma deve ficar oculto ou opcional

Cenário: Tentativa de criar sem selecionar público (Triste)
    Dado que preenchi os dados básicos do formulário
    E não selecionei nem "Docente" nem "Discente"
    Quando tento clicar em "Enviar"
    Então o sistema deve exibir o erro "Selecione o público-alvo da avaliação"
    E não deve enviar o formulário
