# Arquitetura Modular - Finances Control

## Visão Geral da Aplicação

O Finances Control é um aplicativo de gerenciamento financeiro pessoal desenvolvido em Flutter/Dart, projetado para ajudar usuários a controlar suas finanças através de funcionalidades como orçamentos, controle de gastos, categorização de despesas e visualização de dados financeiros.

## Proposta de Arquitetura Modular

### Módulo: Budget Control (Controle de Orçamento)

**Descrição:** Módulo responsável pelo gerenciamento completo de orçamentos, incluindo criação, edição, acompanhamento e análise de limites de gastos por categoria.

**Funcionalidades:**
- Criação e edição de orçamentos mensais/anuais
- Definição de limites por categoria de despesa
- Acompanhamento em tempo real do consumo vs. limite
- Alertas de proximidade do limite
- Relatórios de performance orçamentária
- Histórico de orçamentos anteriores

**Componentes:**
- `budget_control/`
  - `data/` (repositórios, datasources, models)
  - `domain/` (entidades, use cases, repositories interfaces)
  - `ui/` (pages, widgets, components)
  - `bloc/` (state management)

**Por que deve ser um módulo:**
- Funcionalidade completa e independente
- Lógica de negócio complexa e isolada
- Reutilizável para diferentes contextos
- Testabilidade isolada
- Pode ser desenvolvido por equipe separada

---

### Módulo: Transaction Manager (Gerenciador de Transações)

**Descrição:** Módulo para registro, categorização e gerenciamento de todas as transações financeiras (receitas e despesas).

**Funcionalidades:**
- Registro de transações (receitas/despesas)
- Categorização automática e manual
- Importação de extratos bancários
- Edição e exclusão de transações
- Busca e filtragem avançada
- Anexos de comprovantes

**Componentes:**
- `transaction_manager/`
  - `data/` (repositórios, datasources, models)
  - `domain/` (entidades, use cases, repositories interfaces)
  - `ui/` (pages, widgets, components)
  - `bloc/` (state management)

---

### Módulo: Reports & Analytics (Relatórios e Análises)

**Descrição:** Módulo especializado em geração de relatórios financeiros e análises de dados para tomada de decisão.

**Funcionalidades:**
- Relatórios de fluxo de caixa
- Análise de gastos por categoria/período
- Gráficos e visualizações interativas
- Exportação de relatórios (PDF, Excel)
- Comparativos periódicos
- Projeções financeiras

**Componentes:**
- `reports_analytics/`
  - `data/` (repositórios, datasources, models)
  - `domain/` (entidades, use cases, repositories interfaces)
  - `ui/` (pages, widgets, components)
  - `bloc/` (state management)

---

## O QUE MANTER NO APP PRINCIPAL (CORE MODULE) - MAIÚSCULO

### REGRAS FUNDAMENTAIS DO CORE:
- **NUNCA** depender de módulos de features
- **SEMPRE** ser a base para todos os módulos
- **JAMAIS** criar dependências circulares

### 1. NAVEGAÇÃO E ROUTING (OBRIGATÓRIO NO CORE)
- Gerenciamento de rotas GLOBAIS
- Navegação ENTRE MÓDULOS
- Deep linking
- **POR QUE NO CORE:** Controla o fluxo da aplicação inteira

### 2. AUTENTICAÇÃO E SEGURANÇA (OBRIGATÓRIO NO CORE)
- Login/Logout GLOBAL
- Gerenciamento de sessão
- Biometria e segurança
- **POR QUE NO CORE:** Todos os módulos precisam de autenticação

### 3. CONFIGURAÇÕES GLOBAIS (OBRIGATÓRIO NO CORE)
- Preferências do usuário
- Configurações de notificações
- Tema e aparência GLOBAL
- **POR QUE NO CORE:** Afeta toda a aplicação

### 4. STORAGE E PERSISTÊNCIA (OBRIGATÓRIO NO CORE)
- Configuração de banco de dados
- Migrações de schema
- Cache global
- **POR QUE NO CORE:** Base de dados compartilhada

### 5. SERVIÇOS COMPARTILHADOS (OBRIGATÓRIO NO CORE)
- Logger GLOBAL
- Error handling GLOBAL
- Network client BASE
- Localização (i18n)
- **POR QUE NO CORE:** Utilizados por todos os módulos

### 6. UI CORE (OBRIGATÓRIO NO CORE)
- Design system COMPLETO
- Componentes compartilhados
- Temas e estilos GLOBAIS
- **POR QUE NO CORE:** Consistência visual em toda a app

### 7. INJEÇÃO DE DEPENDÊNCIAS (OBRIGATÓRIO NO CORE)
- Configuração do DI container
- Serviços singleton
- **POR QUE NO CORE:** Orquestra todas as dependências

### 8. MODELOS DOMÍNIO COMPARTILHADOS (OBRIGATÓRIO NO CORE)
- Entidades base (User, Transaction, Category)
- Enums globais
- Interfaces compartilhadas
- **POR QUE NO CORE:** Evita duplicação e inconsistências

## REGRAS DE DEPENDÊNCIA - EVITAR CIRCULARIDADE

### DIREÇÃO DAS DEPENDÊNCIAS (OBRIGATÓRIO):
```
CORE MODULE
    ^
    | (depende)
    |
FEATURE MODULES (Budget, Transaction, Reports)
```

### O QUE É PROIBIDO:
- **Módulos de feature NUNCA podem depender uns dos outros**
- **Core NUNCA pode depender de features**
- **Features SÓ podem depender do Core**

### EXEMPLOS PERMITIDOS:
- Budget Control usa User do Core
- Transaction Manager usa Logger do Core
- Reports Analytics usa Network Client do Core

### EXEMPLOS PROIBIDOS:
- Budget Control depende de Transaction Manager
- Core depende de Budget Control
- Transaction Manager depende de Reports Analytics

## Benefícios da Arquitetura Modular

1. **Manutenibilidade:** Isolamento de código facilita manutenção
2. **Escalabilidade:** Módulos podem ser desenvolvidos independentemente
3. **Testabilidade:** Testes unitários e de integração por módulo
4. **Reutilização:** Módulos podem ser reutilizados em outros projetos
5. **Performance:** Carregamento sob demanda de funcionalidades
6. **Trabalho em Equipe:** Times podem trabalhar em módulos diferentes

## Estrutura de Pastas Sugerida

```
lib/
  core/                    # App principal
    auth/
    config/
    navigation/
    shared/
    storage/
    ui/
    services/
    
  features/                # Módulos de features
    budget_control/
    transaction_manager/
    reports_analytics/
    
  main.dart
```

## Implementação Gradual

1. **Fase 1:** Identificar e isolar funcionalidades candidatas a módulos
2. **Fase 2:** Refatorar estrutura existente para suportar modularidade
3. **Fase 3:** Extrair primeiro módulo (Budget Control)
4. **Fase 4:** Continuar com outros módulos gradualmente
5. **Fase 5:** Otimizar comunicação entre módulos

Essa abordagem permite evolução controlada sem quebrar a aplicação existente.
