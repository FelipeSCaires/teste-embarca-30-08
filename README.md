# Lista de Tarefas — Desafio Full Stack

Aplicação full stack para o desafio de Lista de Tarefas: **Ruby on Rails 8 + PostgreSQL 17 + ERB/Hotwire (Turbo & Stimulus)**.

O norte das decisões foi "quanto mais simples, melhor": convenções do Rails, poucos arquivos, controllers enxutos e nada de dependência que o desafio não pede.

## Stack

| Camada | Tecnologia |
| --- | --- |
| Backend | Ruby 3.2.3 · Rails 8.0.5 |
| Banco | PostgreSQL 17 (via docker-compose) |
| Front-end | ERB + Hotwire (Turbo/Stimulus) + Propshaft/Importmap |
| Autenticação | Devise 5 (sessão via cookie) |
| Testes | Minitest (padrão Rails) |

## Como rodar

Pré-requisitos: Ruby 3.2.3, Bundler e Docker.

```bash
# 1. Subir o PostgreSQL (na raiz do repositório, onde está o docker-compose.yaml)
docker compose up -d db

# 2. Instalar as gems (na pasta da aplicação)
cd teste
bundle install

# 3. Criar os bancos e migrar
bin/rails db:create
bin/rails db:migrate

# 4. Subir o servidor
bin/rails server
```

Acesse `http://localhost:3000` — a raiz redireciona para a documentação de rotas
(`/docs/rotas-front.html`). Crie uma conta em `/users/sign_up`; após o login você é
redirecionado para a tela de gerenciamento em `/admin/users`.

> A conexão com o banco usa `localhost:5432` com usuário/senha `postgres`/`postgres`
> (os valores do docker-compose). Tudo é sobrescrevível por variáveis de ambiente:
> `DB_HOST`, `DB_PORT`, `DB_USERNAME`, `DB_PASSWORD`.

## Modelagem

### Implementado

- **User** (Devise): `name`, `email` (único), senha criptografada. CRUD completo em duas
  interfaces — telas HTML (`/admin/users`) e API JSON (`/api/users`) — ambas protegidas
  por autenticação.

### Escopo do desafio (Tasks)

- **Task** `belongs_to :user` / **User** `has_many :tasks`:
  - `title` — obrigatório (`validates :title, presence: true`)
  - `description` — opcional
  - `due_date` — opcional; não pode ser passada (validação customizada)
  - `status` — enum `pendente` / `concluida` (status fora da lista é rejeitado)
- CRUD completo de tarefas: criar, listar, visualizar, editar e excluir, com formulário
  compartilhado (`_form`), feedback de validações e navegação simples.

## Rotas principais

| Rota | Descrição |
| --- | --- |
| `POST /users` · `POST /users/sign_in` · `DELETE /users/sign_out` | Autenticação (HTML e JSON) |
| `GET /admin/users` (+ new/edit/create/update/destroy) | Telas HTML de gerenciamento de usuários |
| `GET/POST/PATCH/DELETE /api/users(/:id)` | API JSON de usuários (sessão obrigatória) |
| `GET /docs/rotas-front.html` | Documentação das rotas para o front |
| `GET /up` | Health check |

A referência completa, com exemplos de request/response e códigos de status, está em
[`public/docs/rotas-front.html`](public/docs/rotas-front.html), servida pela própria aplicação.

## Decisões de arquitetura e trade-offs

- **ERB + Hotwire em vez de SPA**: o desafio tem 1 hora; o stack padrão do Rails entrega
  formulário, listagem e feedback de validação sem build de front separado. Turbo já dá a
  sensação de SPA (confirmação de exclusão, redirects 303) de graça.
- **API JSON em `namespace :api`**: com Devise `registerable`, `POST /users` pertence ao
  cadastro — o CRUD em `/api/users` elimina a colisão de rotas e permite front separado
  (same-origin) consumindo a mesma base.
- **Sessão via cookie em vez de token/JWT**: mais simples, seguro por padrão (SameSite=Lax,
  CSRF ativo no fluxo HTML) e suficiente para o escopo. O skip de CSRF nos endpoints JSON é
  condicionado ao `Content-Type: application/json`, que formulário cross-site não consegue
  forjar.
- **Controllers enxutos**: strong params com `params.expect` (Rails 8), tratamento de erros
  centralizado num `Api::BaseController` (`404`/`400` via `rescue_from`), views com partial
  de formulário compartilhada (DRY).
- **PostgreSQL desde o início** (requisito), com layout de 4 bancos em produção
  (primary/cache/queue/cable) mantido para solid_cache/solid_queue/solid_cable.

## Melhorias possíveis

- Filtro por status, busca por título, ordenação e paginação na listagem de tarefas.
- Contador de pendências por usuário (counter cache ou scope + Turbo Frame).
- Testes automatizados (model: validações; integração: CRUD e autenticação).
- CI: adicionar serviço `postgres:17` ao workflow do GitHub Actions.
- Dockerfile da aplicação: trocar `sqlite3` por `postgresql-client`/`libpq-dev` e criar o
  serviço `web` no docker-compose.
- Autorização por papel (hoje qualquer usuário autenticado gerencia todos os usuários).
