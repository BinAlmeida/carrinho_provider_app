import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/produto.dart';
import 'providers/carrinho_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CarrinhoProvider(),
      child: const CarrinhoApp(),
    ),
  );
}

class CarrinhoApp extends StatelessWidget {
  const CarrinhoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carrinho com Provider',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, useMaterial3: true),
      home: const CatalogoScreen(),
    );
  }
}

class CatalogoScreen extends StatelessWidget {
  const CatalogoScreen({super.key});

  static final List<Produto> _produtos = [
    Produto(id: '1', nome: 'Teclado Mecânico', preco: 250.00),
    Produto(id: '2', nome: 'Mouse Gamer', preco: 120.00),
    Produto(id: '3', nome: 'Monitor 24"', preco: 890.00),
    Produto(id: '4', nome: 'Headset Stereo', preco: 180.00),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Produtos'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CarrinhoScreen(),
                    ),
                  );
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Consumer<CarrinhoProvider>(
                  builder: (context, carrinho, child) {
                    return carrinho.quantidade == 0
                        ? const SizedBox()
                        : CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.red,
                            child: Text(
                              '${carrinho.quantidade}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _produtos.length,
        itemBuilder: (context, index) {
          final prod = _produtos[index];

          return Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            child: ListTile(
              title: Text(
                prod.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'R\$ ${prod.preco.toStringAsFixed(2)}',
              ),
              trailing: Consumer<CarrinhoProvider>(
                builder: (context, carrinho, child) {
                  final estaNoCarrinho =
                      carrinho.itens.contains(prod);

                  return IconButton(
                    icon: Icon(
                      estaNoCarrinho
                          ? Icons.check_circle
                          : Icons.add_shopping_cart,
                      color: estaNoCarrinho
                          ? Colors.green
                          : Colors.teal,
                    ),
                    onPressed: () {
                      carrinho.adicionar(prod);
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class CarrinhoScreen extends StatelessWidget {
  const CarrinhoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Carrinho'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CarrinhoProvider>(
        builder: (context, carrinho, child) {
          if (carrinho.quantidade == 0) {
            return const Center(
              child: Text(
                'Seu carrinho está vazio!',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: carrinho.itens.length,
                  itemBuilder: (context, index) {
                    final item = carrinho.itens[index];

                    final quantidade =
                        carrinho.quantidadeDoProduto(item);

                    return ListTile(
                      title: Text(item.nome),
                      subtitle: Text(
                        'R\$ ${item.preco.toStringAsFixed(2)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              carrinho.diminuir(item);
                            },
                          ),
                          Text(
                            '$quantidade',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Colors.teal,
                            ),
                            onPressed: () {
                              carrinho.adicionar(item);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // CUPOM
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: 'Cupom',
                          hintText: 'DESCONTO10',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (valor) {
                          carrinho.aplicarCupom(valor);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        carrinho.aplicarCupom('DESCONTO10');

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Cupom de 10% aplicado!',
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Aplicar'),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.all(20),
                color: Colors.teal.shade50,
                child: Column(
                  children: [
                    if (carrinho.cupomAplicado)
                      Text(
                        'Desconto: R\$ ${carrinho.desconto.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total: R\$ ${carrinho.valorFinal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          // EXERCÍCIO 03
                          onPressed: () async {
                            final confirmar =
                                await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text(
                                    'Confirmar compra',
                                  ),
                                  content: const Text(
                                    'Deseja realmente finalizar a compra?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                          false,
                                        );
                                      },
                                      child: const Text(
                                        'Cancelar',
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                          true,
                                        );
                                      },
                                      child: const Text(
                                        'Confirmar',
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            if (confirmar == true) {
                              carrinho.limpar();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Compra finalizada com sucesso!',
                                  ),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Finalizar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}