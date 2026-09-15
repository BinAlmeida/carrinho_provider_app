# Carrinho Provider App

Aplicativo desenvolvido em Flutter para praticar gerenciamento de estado utilizando o pacote `provider`, `ChangeNotifier` e `Consumer`.

O projeto simula um catálogo de produtos com carrinho de compras, permitindo adicionar e remover produtos, acompanhar a quantidade de itens e visualizar o valor total da compra.

---

## Versão Base — V.0.0

### Objetivo

Criar uma aplicação Flutter utilizando o padrão de gerenciamento de estado `Provider` para compartilhar e atualizar os dados do carrinho entre diferentes telas.

A atividade trabalha principalmente:

- `ChangeNotifier`;
- `ChangeNotifierProvider`;
- `Consumer`;
- gerenciamento de estado;
- atualização reativa da interface;
- compartilhamento de dados entre widgets.

### O que foi desenvolvido

Foi criado o modelo `Produto`, contendo:

- `id`
- `nome`
- `preco`

Também foi criado o `CarrinhoProvider`, responsável pelo estado do carrinho.

O provider mantém internamente uma lista de produtos:

`_itens`

E disponibiliza os seguintes getters:

- `itens`
- `quantidade`
- `valorTotal`

As principais operações implementadas são:

- `adicionar()`
- `remover()`
- `limpar()`

Após cada alteração no carrinho, o método `notifyListeners()` é executado para atualizar automaticamente os widgets que estão observando o provider.

A aplicação é inicializada utilizando:

`ChangeNotifierProvider`

As informações do carrinho são consumidas na interface através de:

`Consumer<CarrinhoProvider>`

A aplicação possui duas partes principais:

### Catálogo

Apresenta uma lista de produtos com:

- nome;
- preço;
- botão para adicionar o produto ao carrinho.

Quando o produto já está no carrinho, o ícone muda para indicar que ele foi selecionado.

### Carrinho

Apresenta:

- produtos adicionados;
- preço de cada item;
- opção para remover produtos;
- quantidade total de itens;
- valor total da compra;
- botão `Finalizar`.

### Resultado

A versão base apresenta um carrinho funcional com gerenciamento de estado centralizado no `CarrinhoProvider`.

Quando um produto é adicionado ou removido, as informações do catálogo e do carrinho são atualizadas automaticamente.

---

## Exercício 01 — V.0.0.1

### Objetivo

Adicionar uma quantidade individual para cada produto dentro do carrinho, permitindo aumentar e diminuir a quantidade de cada item.

### O que mudou

O gerenciamento do carrinho foi adaptado para controlar a quantidade individual dos produtos.

Foram adicionados controles para aumentar ou diminuir a quantidade de cada item.

O usuário passou a poder realizar operações como:

`+` → aumentar quantidade

`-` → diminuir quantidade

O valor total passa a considerar as quantidades dos produtos.

Por exemplo:

`Produto = R$ 10,00`

`Quantidade = 3`

`Subtotal = R$ 30,00`

A interface do carrinho passou a apresentar os controles de quantidade junto com cada produto.

### Resultado

O carrinho passou a funcionar de forma mais próxima de um carrinho de compras real, permitindo que o mesmo produto possua várias unidades sem precisar cadastrar o produto repetidamente.

---

## Exercício 02 — V.0.0.2

### Objetivo

Criar uma funcionalidade de cupom de desconto no carrinho.

### O que mudou

Foi adicionada uma funcionalidade para aplicar um desconto de `10%` sobre o valor total.

Foi criado no `CarrinhoProvider` o gerenciamento relacionado ao desconto e ao valor final da compra.

Na interface do carrinho foi adicionado um campo para inserir o cupom e um botão para aplicá-lo.

Quando o cupom válido é informado, o desconto é calculado sobre o valor do carrinho.

O fluxo passou a ser:

1. Produtos são adicionados ao carrinho.
2. O sistema calcula o valor total.
3. O usuário informa o cupom.
4. O cupom é aplicado.
5. O desconto é apresentado.
6. O valor final é atualizado.

A funcionalidade de quantidade individual do Exercício 01 foi preservada.

### Resultado

O carrinho passou a permitir a aplicação de um cupom de desconto de 10%, apresentando o valor atualizado da compra.

---

## Exercício 03 — V.0.0.3

### Objetivo

Adicionar uma confirmação antes de finalizar a compra e limpar os produtos do carrinho.

### O que mudou

O botão `Finalizar` deixou de executar diretamente:

`carrinho.limpar()`

Antes de limpar os itens, a aplicação passou a exibir um `Dialog` de confirmação.

O fluxo passou a ser:

1. O usuário clica em `Finalizar`.
2. A aplicação abre um diálogo.
3. O usuário escolhe `Cancelar` ou `Confirmar`.
4. Caso escolha `Cancelar`, o carrinho permanece intacto.
5. Caso escolha `Confirmar`, o método `limpar()` é executado.
6. O carrinho é esvaziado.
7. Uma `SnackBar` informa que a compra foi finalizada com sucesso.

A confirmação utiliza uma mensagem semelhante a:

`Deseja realmente finalizar a compra?`

Foram preservadas as funcionalidades das versões anteriores:

- quantidade individual dos produtos;
- aumento e diminuição da quantidade;
- cupom de desconto;
- cálculo do desconto;
- cálculo do valor final;
- gerenciamento de estado com Provider.

### Resultado

A aplicação passou a exigir confirmação antes de finalizar a compra, evitando que o carrinho seja limpo acidentalmente.

---

## Histórico de Versões

| Versão | Exercício | Alteração principal |
|---|---|---|
| **V.0.0** | Base | Carrinho utilizando Provider e ChangeNotifier |
| **V.0.0.1** | Exercício 01 | Quantidade individual por produto |
| **V.0.0.2** | Exercício 02 | Cupom de desconto de 10% |
| **V.0.0.3** | Exercício 03 | Confirmação com `Dialog` antes de finalizar |

---

## Tecnologias utilizadas

- Flutter
- Dart
- Material Design
- Provider
- ChangeNotifier
- Consumer

---

## Estrutura principal

carrinho_provider_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   └── produto.dart
│   └── providers/
│       └── carrinho_provider.dart
├── pubspec.yaml
└── ...

### Gerenciamento de Estado

O CarrinhoProvider é responsável por armazenar e controlar os dados do carrinho.

A estrutura principal utiliza:

##### ChangeNotifier

para notificar as alterações de estado.

No ponto de entrada da aplicação é utilizado:

##### ChangeNotifierProvider

para disponibilizar o provider aos widgets da aplicação.

Nas telas que precisam acompanhar as alterações do carrinho é utilizado:

##### Consumer<CarrinhoProvider>

Dessa forma, quando notifyListeners() é executado, os widgets que dependem do provider são reconstruídos com os novos valores.

## Funcionalidades
#### Catálogo
- Exibição dos produtos;
- preço dos produtos;
- botão para adicionar ao carrinho;
- indicação visual quando um produto já está no carrinho.
#### Carrinho
- Listagem dos produtos;
- controle de quantidade;
- remoção de produtos;
- cálculo do valor total;
- aplicação de cupom de desconto;
- exibição do valor final;
- finalização da compra;
- confirmação antes de limpar o carrinho.

## Execução

Para instalar as dependências:

#### flutter pub get

Para executar no Chrome:

#### flutter run -d chrome

No Google Cloud Shell:

#### flutter run -d web-server --web-port 8080 --web-hostname 0.0.0.0

Depois, no Web Preview, selecionar a porta 8080.

## O CUPOM VÁLIDO SERÁ: "DESCONTO10"
