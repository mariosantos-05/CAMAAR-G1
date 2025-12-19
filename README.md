# CAMAAR – Sistema de Avaliação de Atividades Acadêmicas Remotas do CIC

## 📌 Visão Geral

O **CAMAAR** é um sistema web desenvolvido para apoiar a avaliação de atividades acadêmicas remotas no âmbito do CIC. Ele permite o cadastro e gerenciamento de usuários, criação e aplicação de formulários de avaliação, importação e sincronização de dados do SIGAA, além da geração e visualização de relatórios administrativos.

O projeto foi desenvolvido seguindo práticas de **Engenharia de Software Ágil**, com uso intensivo de **BDD (Cucumber)**, **TDD (RSpec)**, métricas de qualidade de código (ABC Score, Complexidade Ciclomática) e documentação em **RDoc**.

---

## 👥 Equipe – Grupo 1 (Engenharia de Software)

| Nome        | Matrícula |
| ----------- | --------- |
| Caroline    | 232050975 |
| Célio       | 211010350 |
| Luís Filipe | 190091975 |
| Mario       | 231035778 |

---

## 🛠️ Tecnologias Utilizadas

* **Ruby on Rails**
* **RSpec** (testes automatizados)
* **Cucumber** (BDD)
* **PostgreSQL**
* **Rubycritic / Flog** (métricas de qualidade)
* **RDoc** (documentação de código)

---

## 🚀 Funcionalidades Principais

* Sistema de login e definição/redefinição de senha
* Cadastro e importação de usuários via SIGAA
* Criação e gerenciamento de templates de formulários
* Criação de formulários de avaliação por turma
* Resposta de formulários por participantes
* Visualização de formulários pendentes
* Visualização e exportação de resultados (CSV)
* Controle de acesso por perfil e departamento

---

## 📂 Organização do Projeto

* `app/` – Código-fonte principal
* `spec/` – Testes automatizados (RSpec)
* `features/` – Cenários BDD (Cucumber)
* `docs/` – Documentação adicional
* `Como Usar.md` – Guia para execução e testes do sistema

---

## 🌿 Política de Branching

Utilizamos **Sprint Branching + Feature Branching** (variação do GitLab Flow):

1. Criação de uma branch da sprint a partir da `main`
2. Criação de branches de feature a partir da branch da sprint
3. Consolidação das features na branch da sprint
4. Merge final da sprint para a `main`

---

## 📊 Qualidade de Código

* **ABC Score < 20** por método
* **Cobertura de testes > 90%** (controllers e models)
* Todos os testes contemplam **Happy Path** e **Sad Path**
* Código totalmente documentado com **RDoc**

---

## ▶️ Como Executar o Projeto

As instruções completas de instalação, configuração e uso estão disponíveis no arquivo:

📄 **`Como Usar.md`**

---

## 📚 Wiki do Projeto (GitHub Wiki)

A documentação detalhada de cada sprint está disponível na Wiki do GitHub, organizada nas seguintes páginas:

* **Sprint-1.md** – Planejamento, escopo, regras de negócio e BDD
* **Sprint-2.md** – Implementação das User Stories e testes
* **Sprint-3.md** – Refatoração, métricas de qualidade e documentação

## ✅ Status do Projeto

📦 **Projeto finalizado com sucesso**, atendendo a todos os critérios técnicos e acadêmicos definidos para a disciplina.
