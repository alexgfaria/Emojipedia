# Bliss Apps Challenge – iOS
Tech assessment for Bliss Apps

## Funcionalidades Implementadas

Este projeto implementa os requisitos do desafio técnico Bliss Apps, utilizando SwiftUI, arquitetura MVVM, Core Data para persistência local, e networking assíncrono com async/await.

### 1. Emojis
#### 1.1 Emoji Aleatório
- Ao clicar no botão, um emoji aleatório é selecionado e mostrado em destaque no topo do ecrã.

#### 1.2 Lista de Emojis
- Os emojis são obtidos da API pública do GitHub (https://api.github.com/emojis) utilizando uma chamada assíncrona com tratamento de erros.
- Os dados recebidos são mostrados numa grid com SwiftUI.

##### 1.2.1 Exclusão de Emojis e Pull to Refresh
- O utilizador pode remover emojis da memória temporária clicando nele.
- Um gesto de pull-to-refresh permite restaurar a lista completa de emojis.

#### 1.3 Persistência com Core Data
- A lista de emojis é guardada localmente com Core Data.
- Ao abrir a app, se houver dados persistidos, eles são carregados automaticamente.

### 2. Avatares do GitHub
#### 2.1 Busca de Avatares
- O utilizador pode buscar avatares do GitHub pelo nome de utilizador.
- A busca utiliza a API do GitHub e mostra o avatar correspondente, com tratamento de erros para utilizadores inexistentes.

#### 2.2 Cache de Avatares
- Avatares buscados são guardados localmente (cache em Core Data), evitando requisições repetidas desnecessárias.
- Caso o avatar já esteja guardado, a app mostra a versão em cache.

#### 2.3 Lista e Exclusão
- Todos os avatares buscados são listados num ecrã dedicado.
- O utilizador pode remover avatares individualmente da base de dados local ao clicar e confirmando no diálogo.

### 3. Repositórios da Apple
#### 3.1 Lista de Repositórios
- A app lista os repositórios públicos da Apple no GitHub, utilizando a API de busca de repositórios.

#### 3.2 Paginação
- O ecrã de repositórios implementa paginação: ao fazer scroll até ao fim da lista, novas páginas de repositórios são carregadas automaticamente.

## Detalhes Técnicos e Extras
- **Persistência:** Core Data é utilizado para armazenar emojis e avatares localmente.
- **UI:** SwiftUI é usado para todas as ecrãs, com NavigationStack para navegação.
- **Networking:** Todas as requisições são feitas com async/await, incluindo tratamento de erros e estados de carregamento.
- **Cache:** Avatares buscados ficam guardados localmente para acelerar buscas futuras.
- **Refinamentos de UI:** Uso de bordas, espaçamentos, grid e layouts adaptativos.
- **Arquitetura:** MVVM, separando regras de negócio (ViewModels), serviços de rede, e stores de persistência.

## Notas Finais
O projeto segue a arquitetura MVVM, com separação clara entre responsabilidades. Serviços de rede e persistência (Core Data) são desacoplados das views. O uso de SwiftUI e NavigationStack facilita a navegação e organização das ecrãs. O código é modular, facilitando manutenção e extensões futuras.
