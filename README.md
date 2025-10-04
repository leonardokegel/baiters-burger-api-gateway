# API Gateway - Baiters Burger

## Sumário
- [Visão Geral](#-visão-geral)
- [Arquitetura](#-arquitetura)
- [Endpoints](#-endpoints)
  - [Customers (Clientes)](#customers-clientes)
  - [Products (Produtos)](#products-produtos)
  - [Orders (Pedidos)](#orders-pedidos)
- [Schemas](#-schemas)
- [Exemplos de Uso](#-exemplos-de-uso)
- [Códigos de Status](#-códigos-de-status)
- [Configuração do Terraform](#-configuração-do-terraform)

## Visão Geral

A **API Baiters Burger** é um sistema completo para gerenciar uma hamburgueria, oferecendo funcionalidades para:
- **Gestão de Clientes**: Cadastro e consulta de clientes
- **Gestão de Produtos**: CRUD completo de produtos organizados por categorias
- **Gestão de Pedidos**: Criação, listagem e atualização do status de pedidos

### Informações da API
- **Versão**: 1.0.0
- **Base URL**: `/api/v1`
- **Formato**: JSON
- **Protocolo**: HTTPS

## Arquitetura

A API utiliza **AWS API Gateway** com integração via **VPC Link** para comunicação com serviços internos através de um **Network Load Balancer (NLB)**.

### Componentes:
- **API Gateway**: Ponto de entrada da API
- **VPC Link**: Conexão segura entre API Gateway e recursos VPC
- **Network Load Balancer**: Distribuição de carga para os serviços backend

## Endpoints

### Customers (Clientes)

#### Cadastrar Cliente
```http
POST /api/v1/customers
```

**Descrição**: Cadastra um novo cliente no sistema.

**Body**:
```json
{
  "name": "teste",
  "cpf": "60638312078",
  "email": "teste@gmail.com"
}
```

**Resposta**: `201 Created`

---

#### 🔍 Buscar Cliente por CPF
```http
GET /api/v1/customers/{cpf}
```

**Descrição**: Busca um cliente específico pelo CPF.

**Parâmetros**:
- `cpf` (path, obrigatório): CPF do cliente

**Resposta**: `200 OK`
```json
{
  "cpf": "48481743844",
  "name": "mirna",
  "email": "mirna@gmail.com"
}
```

---

### Products (Produtos)

#### Cadastrar Produto
```http
POST /api/v1/products
```

**Descrição**: Cadastra um novo produto no cardápio.

**Body**:
```json
{
  "productName": "Produto 23",
  "category": "BURGERS",
  "price": 100.00,
  "description": "burguer 2 exemplo",
  "imagesUrls": ["http://example.com/image1.jpg"]
}
```

**Resposta**: `201 Created`

---

#### 📋 Listar Produtos
```http
GET /api/v1/products?category={category}
```

**Descrição**: Lista todos os produtos, opcionalmente filtrado por categoria.

**Parâmetros de Query**:
- `category` (opcional): Filtra por categoria
  - Valores possíveis: `BURGERS`, `SIDE_DISHES`, `DRINKS`, `DESSERTS`

**Resposta**: `200 OK`
```json
[
  {
    "productName": "X-Burger",
    "category": "BURGERS",
    "price": 0.01,
    "description": "Product Description",
    "imagesUrls": ["http://example.com/image1.jpg"]
  },
  {
    "productName": "X-Everything",
    "category": "BURGERS",
    "price": 0.01,
    "description": "p",
    "imagesUrls": ["http://example.com/image1.jpg"]
  }
]
```

---

#### Buscar Produto por ID
```http
GET /api/v1/products/{product_id}
```

**Descrição**: Busca um produto específico pelo ID.

**Parâmetros**:
- `product_id` (path, obrigatório): ID do produto

**Resposta**: `200 OK`
```json
{
  "productName": "X-Burger",
  "category": "BURGERS",
  "price": 0.01,
  "description": "Product Description",
  "imagesUrls": ["http://example.com/image1.jpg"]
}
```

---

#### Atualizar Produto
```http
PUT /api/v1/products/{product_id}
```

**Descrição**: Atualiza um produto existente.

**Parâmetros**:
- `product_id` (path, obrigatório): ID do produto

**Body**: Mesmo formato do POST de criação

**Resposta**: `200 OK`

---

### Orders (Pedidos)

#### Criar Pedido
```http
POST /api/v1/orders
```

**Descrição**: Cria um novo pedido.

**Body**:
```json
{
  "productsIds": ["683a3be2eea4980451cfad26", "683a3c04eea4980451cfad27"],
  "customerCpf": "41003884032"
}
```

**Resposta**: `201 Created`

---

#### 📋 Listar Pedidos
```http
GET /api/v1/orders?status={status}
```

**Descrição**: Lista todos os pedidos, opcionalmente filtrado por status.

**Parâmetros de Query**:
- `status` (opcional): Filtra por status
  - Valores possíveis: `REQUESTED`, `RECEIVED`, `PREPARING`, `READY`, `DELIVERED`

**Resposta**: `200 OK`
```json
[
  {
    "id": "68895ec6e6b7565abfa6c833",
    "totalPrice": 0.02,
    "status": "READY",
    "products": [
      {
        "productName": "X-Burger",
        "category": "BURGERS",
        "description": "Product Description"
      },
      {
        "productName": "X-Salad",
        "category": "BURGERS",
        "description": "Product Description"
      }
    ],
    "createdAt": "2025-07-29T20:52:38.067Z",
    "name": "Daniel Ferreira"
  }
]
```

---

#### ✏️ Atualizar Status do Pedido
```http
PATCH /api/v1/orders/{order_id}
```

**Descrição**: Atualiza o status de um pedido específico.

**Parâmetros**:
- `order_id` (path, obrigatório): ID do pedido

**Body**:
```json
{
  "status": "PREPARING"
}
```

**Resposta**: `200 OK`

---

## 📊 Schemas

### Customer (Cliente)
```json
{
  "cpf": "string",
  "name": "string", 
  "email": "string (formato email)"
}
```

### CustomerInput
```json
{
  "name": "string" (obrigatório),
  "cpf": "string" (obrigatório),
  "email": "string (formato email)" (obrigatório)
}
```

### Product (Produto)
```json
{
  "productName": "string",
  "category": "string",
  "price": "number (float)",
  "description": "string",
  "imagesUrls": ["string (uri)"]
}
```

### ProductInput
```json
{
  "productName": "string" (obrigatório),
  "category": "string" (obrigatório),
  "price": "number (float)" (obrigatório),
  "description": "string" (obrigatório),
  "imagesUrls": ["string (uri)"] (opcional)
}
```

### Order (Pedido)
```json
{
  "id": "string",
  "totalPrice": "number (float)",
  "status": "string",
  "products": [
    {
      "productName": "string",
      "category": "string", 
      "description": "string"
    }
  ],
  "createdAt": "string (datetime)",
  "name": "string"
}
```

### OrderInput
```json
{
  "productsIds": ["string"] (obrigatório),
  "customerCpf": "string" (opcional)
}
```

---

## 🧪 Exemplos de Uso

### Fluxo Completo de Pedido

1. **Cadastrar Cliente**:
```bash
curl -X POST /api/v1/customers \
  -H "Content-Type: application/json" \
  -d '{
    "name": "João Silva",
    "cpf": "12345678901", 
    "email": "joao@email.com"
  }'
```

2. **Listar Produtos por Categoria**:
```bash
curl -X GET "/api/v1/products?category=BURGERS"
```

3. **Criar Pedido**:
```bash
curl -X POST /api/v1/orders \
  -H "Content-Type: application/json" \
  -d '{
    "productsIds": ["product_id_1", "product_id_2"],
    "customerCpf": "12345678901"
  }'
```

4. **Atualizar Status do Pedido**:
```bash
curl -X PATCH /api/v1/orders/{order_id} \
  -H "Content-Type: application/json" \
  -d '{
    "status": "PREPARING"
  }'
```

---

## Códigos de Status

### Códigos de Sucesso
- `200 OK`: Operação realizada com sucesso
- `201 Created`: Recurso criado com sucesso

### Códigos de Erro
- `400 Bad Request`: Dados inválidos na requisição
- `404 Not Found`: Recurso não encontrado
- `500 Internal Server Error`: Erro interno do servidor

---


## 📞 Suporte

Para dúvidas ou suporte técnico relacionado à API, consulte a documentação do projeto ou entre em contato com a equipe de desenvolvimento.
