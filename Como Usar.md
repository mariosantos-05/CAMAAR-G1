# 🛠️ Guia de Execução e Testes (Sprint 3)

Este guia descreve o fluxo necessário para configurar o ambiente, realizar o primeiro acesso administrativo, popular o banco de dados e executar as baterias de testes e métricas de qualidade.

## Opção 1: Rodar Localmente (Recomendada para desenvolvimento)

1.  **Instale as dependências** (caso ainda não tenha feito):

    ```bash
    bundle install
    ```

2.  **Prepare o banco de dados**:

    ```bash
    bin/rails db:reset
    ```

3.  **Execute o sistema**:
    Use o comando abaixo, que lê o seu arquivo `Procfile.dev`:

    ```bash
    ./bin/dev
    ```

    *Acesse em: `http://localhost:3000`*

## 1\. Login Inicial

Antes de iniciar a aplicação como aluno ou professor, é necessário acessar como **Administrador**. O sistema possui um *seed* configurado para criar este usuário padrão, que é criado rodando os comandos anteriores.


## 2\. Fluxo de Acesso e Utilização

O sistema segue uma ordem lógica de dependência de dados. Siga os passos abaixo para testar o fluxo completo:

### Passo 1: Login Administrativo

O primeiro acesso deve ser feito pelo Administrador para configurar o sistema.

1.  Acesse a rota `/login`.
2.  Utilize as credenciais padrão criadas pelo seed:
      - **Login:** `admin` (ou `admin@camaar.unb.br`)
      - **Senha:** `Admin123`

### Passo 2: Importação de Dados (SIGAA)

Após logar como Admin, você será redirecionado para o Painel Administrativo. O sistema precisa dos dados de turmas e alunos para funcionar.

1.  No menu, clique em **"Importar Dados do SIGAA"** (ou acesse `/importar_sigaa`).
2.  Realize o upload dos arquivos JSON nesta ordem (ou conforme a lógica do seu importador):
      - `classes.json` (Dados das turmas)
      - `class_members.json` (Vínculos de alunos e professores)
3.  O sistema processará os arquivos e criará os usuários com status **Inativo** e **Sem Senha**.

### Passo 3: Criação de Templates e Formulários

Com os dados carregados:

1.  O Admin deve criar um **Template de Avaliação** (perguntas).
2.  O Admin deve criar um **Formulário** vinculando este template a uma Turma específica (importada no passo anterior).

### Passo 4: Primeiro Acesso de Usuário (Aluno/Professor)

Agora que os usuários foram importados, eles podem acessar o sistema.

1.  O usuário acessa a tela de login.
2.  Informa sua **Matrícula** (ex: vinda do `class_members.json`) ou **E-mail**.
3.  Como é o primeiro acesso (usuário importado sem senha), o sistema detectará `password_digest: nil` e redirecionará para a tela de **Definição de Senha**.
4.  O usuário define sua nova senha.
5.  O sistema ativa o cadastro (`status: true`) e loga o usuário automaticamente.
6.  O usuário é redirecionado para responder aos questionários pendentes.

-----

## 3\. Execução de Testes e Métricas

Para garantir a qualidade do código entregue nesta Sprint, utilizamos as seguintes ferramentas. Execute os comandos na raiz do projeto:

### 🧪 Testes Automatizados (RSpec)

Roda todos os testes de unidade e integração (Models e Requests).

```bash
bundle exec rspec
```

  * **Critério de Aceite:** Todos os testes devem passar (0 failures).

### 📈 Cobertura de Código (SimpleCov)

A cobertura é calculada automaticamente ao rodar o RSpec.

1.  Rode o comando do RSpec acima.
2.  Abra o relatório gerado em:
    ```
    coverage/index.html
    ```

<!-- end list -->

  * **Critério de Aceite:** Cobertura global \> 90%.

### Complexity & Code Smells

#### Complexidade Ciclomática (Saikuro)

Não foi necessário, está com status "depecrated"

#### Qualidade e ABC Score (RubyCritic)

Analisa a qualidade geral, duplicidade e complexidade (Assignment, Branch, Condition).

```bash
bundle exec rubycritic app/controllers
```

  * O relatório será aberto automaticamente ou salvo em `tmp/rubycritic/overview.html`.
  * **Meta:** ABC Score \< 20 e classificação "A" nos arquivos principais.

-----

## 4\. Documentação do Código

A documentação técnica dos controladores foi gerada utilizando **RDoc**. Para visualizar:

1.  Gere a documentação (caso não exista):
    ```bash
    bundle exec rdoc app/ --output doc/app --title "Documentação CAMAAR-G1"
    ```
2.  Abra o arquivo `doc/controllers/index.html` no navegador.
3.  Navegue pelas classes para ver os detalhes de métodos, parâmetros e retornos.