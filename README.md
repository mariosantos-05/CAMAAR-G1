
# 📝 Wiki do Projeto – Sprint 3:

**Grupo 1 – Engenharia de Software**  
**Integrantes:**

| Nome        | Matrícula |
| :---------- | :-------- |
| Caroline    | 232050975 |
| Célio       | 211010350 |
| Luís Filipe | 190091975 |
| Mário       | 231035778 |


# 🔰 Sprint 3

O presente relatório detalha as atividades e os resultados alcançados pela equipe durante a Sprint 3. O objetivo principal foi consolidar a qualidade e a manutenibilidade do código-fonte criado, efetuar a refatoração do Código, simplificando e isolando a lógica de negócios mais complexa, com o foco em melhorar as métricas de qualidade, como o ABC Score e a Complexidade Ciclomática, conforme exigido pelas normas técnicas. Além disso, a documentação do código-fonte visa assegurar que ele esteja plenamente documentado (utilizando sintaxe RDoc) e que a interface de usuário (UI) seja clara e funcional.

# 🔰 Papéis na Sprint 3


● A implementação das features cujos cenários BDD especificados na segunda etapa da Sprint 1
Responsáveis: Caroline, Célio, Luís Filipe e Mário.

● Os respectivos testes em RSpec implementados com sucesso.
Responsáveis: Caroline, Célio, Luís Filipe e Mário.

● A documentação das features na Wiki do repositório (com os respectivos responsáveis)
Responsáveis: Caroline, Célio, Luís Filipe e Mário.

● O link do repositório do Github do grupo com todas as informações acima atualizadas.
Responsável: Mário    

● Abrir uma Pull Request com as especificações dos testes de aceitação
(BDD) no repositório principal.  
Responsável: Mário ou Célio

● Entregar arquivo .txt contendo um link para o repositório, o nome e a
matrícula dos integrantes.  
Responsável: Mário    

● Criar um arquivo Markdown como Wiki, contendo
as informações sobre a Sprint 3.  
Responsáveis: Caroline, Célio, Luís Filipe e Mário.


## 🧑‍💼 Scrum Master

Caroline

## 🧑‍💻 Product Owner

Célio

## 🧑‍💻 Produção

Caroline, Célio, Luís Filipe e Mário.

# Refatoração

## 1. `AdminsController`

### Tabela de Comparação por Método

Cada dado apresentado a seguir foi extraído a partir do comando:

`bundle exec flog -a -m app/controllers/admins_controller.rb`

**Tabela 1:** Comparação do ABC Score antes e depois da refatoração de cada método do arquivo `admins_controller.rb`

|**Método**|**ABC Score (Antes)**|**ABC Score (Depois)**|**Resultado**|
|---|---|---|---|
|`export_csv`|49.8|11.2|Refatorado|
|`create_import`|20.4|10.8|Refatorado|
|`show_respostas`|10.7|10.7|Permaneceu igual|
|`require_admin`|10.6|10.4|Refatorado|
|`results`|6.0|6.0|Permaneceu igual|
|`load_export_data`|---|14.4|Novo método extraído|
|`attempt_import_process`|---|12.3|Novo método extraído|
|`build_csv_row`|---|12.2|Novo método extraído|
|`generate_csv_string`|---|12.0|Novo método extraído|
|`redirect_missing_file`|---|2.4|Novo método extraído|
|`redirect_empty_turma`|---|2.4|Novo método extraído|
|`send_csv_file`|---|1.1|Novo método extraído|

No `Rubycritic`, o resultado foi:

**Tabela:** Comparação da complexidade/método antes e depois da refatoração do arquivo `admins_controller.rb`

|**Arquivo**|**Complexidade/método (Antes)**|**Complexidade/método (Depois)**|**Resultado**|
|---|---|---|---|
|`admins_controller.rb`|15.5|10.0|Refatorado|

## 2. `SigaaImportService`

### Tabela de Comparação por Método

Cada dado apresentado a seguir foi extraído a partir do comando:

`bundle exec flog -a -m app/services/sigaa_import_service.rb`

**Tabela:** Comparação do ABC Score antes e depois da refatoração de cada método do arquivo `sigaa_import_service.rb`

|**Método**|**ABC Score (Antes)**|**ABC Score (Depois)**|**Resultado**|
|---|---|---|---|
|`process_members_file`|19.8|3.6|Refatorado|
|`process_classes_file`|15.1|15.1|Permaneceu igual|
|`process_single_user`|14.5|7.7|Refatorado|
|`find_turma`|12.7|12.7|Permaneceu igual|
|`validate_students_data`|12.5|12.5|Permaneceu igual|
|`process_entry`|8.3|8.3|Permaneceu igual|
|`parse_json_file`|7.4|7.4|Permaneceu igual|
|`validate_keys!`|5.5|5.5|Permaneceu igual|
|`call`|5.3|5.3|Permaneceu igual|
|`setup_new_user`|4.8|4.8|Permaneceu igual|
|`initialize`|1.1|1.1|Permaneceu igual|
|`persist_members`|---|9.4|Novo método extraído|
|`validate_members_payload`|---|8.8|Novo método extraído|
|`persist_usuario`|---|7.5|Novo método extraído|
|`create_vinculo`|---|2.0|Novo método extraído|

No `Rubycritic`, o resultado foi:

**Tabela:** Comparação da complexidade/método antes e depois da refatoração do arquivo `sigaa_import_service.rb`

| **Arquivo**               | **Complexidade/método (Antes)** | **Complexidade/método (Depois)** | **Resultado** |
| ------------------------- | ------------------------------- | -------------------------------- | ------------- |
| `sigaa_import_service.rb` | 17.7                            | 7.5                              | Refatorado    |

## 3. `FormsController`

### Tabela de Comparação por Método

No `Rubycritic`, o resultado foi:

**Tabela:** Comparação da complexidade/método antes e depois da refatoração do arquivo `FormsController.rb`

|**Arquivo**|**Complexidade/método (Antes)**|**Complexidade/método (Depois)**|**Resultado**|
|---|---|---|---|
|`FormsController.rb`|16.8|4.3|Refatorado|

## 4. `AvaliacoesController`

### Tabela de Comparação por Método

No `Rubycritic`, o resultado foi:

**Tabela:** Comparação da complexidade/método antes e depois da refatoração do arquivo `AvaliacoesController.rb`

|**Arquivo**|**Complexidade/método (Antes)**|**Complexidade/método (Depois)**|**Resultado**|
|---|---|---|---|
|`AvaliacoesController.rb`|19.8|7.9|Refatorado|

# Quais funcionalidades foram desenvolvidas?


As US desta sprint são:  
[02 - Edição e deleção de templates](https://github.com/mariosantos-05/CAMAAR-G1/issues/2)  
[03 - Visualização dos templates criados](https://github.com/mariosantos-05/CAMAAR-G1/issues/3)  
[04 - Importar dados do SIGAA](https://github.com/mariosantos-05/CAMAAR-G1/issues/4)  
[05 - Responder formulário](https://github.com/mariosantos-05/CAMAAR-G1/issues/5)  
[06 - Cadastrar usuários do sistema](https://github.com/mariosantos-05/CAMAAR-G1/issues/6)  
[07 - Gerar relatório do Administrador](https://github.com/mariosantos-05/CAMAAR-G1/issues/7)  
[08 - Criar template de formulário](https://github.com/mariosantos-05/CAMAAR-G1/issues/8)  
[09 - Criar formulários de avaliação](https://github.com/mariosantos-05/CAMAAR-G1/issues/9)  
[10 - Sistema de login](https://github.com/mariosantos-05/CAMAAR-G1/issues/10)  
[11 - Sistema de definição de senha](https://github.com/mariosantos-05/CAMAAR-G1/issues/11)  
[12 - Sistema de gerenciamento por departamento](https://github.com/mariosantos-05/CAMAAR-G1/issues/12)  
[13 - Redefinição de senha](https://github.com/mariosantos-05/CAMAAR-G1/issues/13)  
[14 - Atualizar base de dados com os dados do SIGAA](https://github.com/mariosantos-05/CAMAAR-G1/issues/14)  
[15 - Visualização de formlários para responder](https://github.com/mariosantos-05/CAMAAR-G1/issues/15)  
[16 - Visualização de Resultado dos Formulários](https://github.com/mariosantos-05/CAMAAR-G1/issues/16)  
[17 - Criação de formulário para docentes ou discentes](https://github.com/mariosantos-05/CAMAAR-G1/issues/17)



## Quem ficou responsável por cada implementação BDD em relação as US/Issues?

#[02](https://github.com/mariosantos-05/CAMAAR-G1/issues/2) Luís Filipe  
#[03](https://github.com/mariosantos-05/CAMAAR-G1/issues/3) Luís Filipe  
#[04](https://github.com/mariosantos-05/CAMAAR-G1/issues/4) Caroline  
#[05](https://github.com/mariosantos-05/CAMAAR-G1/issues/5) Mário  
#[06](https://github.com/mariosantos-05/CAMAAR-G1/issues/6) Célio  
#[07](https://github.com/mariosantos-05/CAMAAR-G1/issues/7) Caroline  
#[08](https://github.com/mariosantos-05/CAMAAR-G1/issues/8) Luís Filipe  
#[09](https://github.com/mariosantos-05/CAMAAR-G1/issues/9) Mário  
#[10](https://github.com/mariosantos-05/CAMAAR-G1/issues/10) Célio  
#[11](https://github.com/mariosantos-05/CAMAAR-G1/issues/11) Célio  
#[12](https://github.com/mariosantos-05/CAMAAR-G1/issues/12) Caroline  
#[13](https://github.com/mariosantos-05/CAMAAR-G1/issues/13) Célio  
#[14](https://github.com/mariosantos-05/CAMAAR-G1/issues/14) Caroline  
#[15](https://github.com/mariosantos-05/CAMAAR-G1/issues/15) Mário  
#[16](https://github.com/mariosantos-05/CAMAAR-G1/issues/16) Mário  
#[17](https://github.com/mariosantos-05/CAMAAR-G1/issues/17) Luís Filipe

---

# 🌿 Política de Branching Utilizada pelo Grupo

Sprint Branching + Feature Branching (variação do GitLab Flow):

- A equipe cria uma branch representando a sprint a partir da main.

- Todas as feature branches da sprint nascem a partir dela.

- No final da sprint, tudo é consolidado e mergeado para a branch da sprint.
