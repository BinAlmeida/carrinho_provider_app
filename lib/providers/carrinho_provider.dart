import 'package:flutter/foundation.dart';
import '../models/produto.dart';

class CarrinhoProvider extends ChangeNotifier {
  final List<Produto> _itens = [];

  final Map<String, int> _quantidades = {};

  bool _cupomAplicado = false;

  List<Produto> get itens => List.unmodifiable(_itens);

  int get quantidade {
    return _quantidades.values.fold(
      0,
      (total, quantidade) => total + quantidade,
    );
  }

  double get valorTotal {
    return _itens.fold(
      0.0,
      (total, item) =>
          total +
          (item.preco * (_quantidades[item.id] ?? 0)),
    );
  }

  bool get cupomAplicado => _cupomAplicado;

  double get desconto {
    if (_cupomAplicado) {
      return valorTotal * 0.10;
    }

    return 0.0;
  }

  double get valorFinal {
    return valorTotal - desconto;
  }

  int quantidadeDoProduto(Produto produto) {
    return _quantidades[produto.id] ?? 0;
  }

  void adicionar(Produto produto) {
    if (!_itens.contains(produto)) {
      _itens.add(produto);
      _quantidades[produto.id] = 1;
    } else {
      _quantidades[produto.id] =
          (_quantidades[produto.id] ?? 0) + 1;
    }

    notifyListeners();
  }

  void diminuir(Produto produto) {
    if (!_quantidades.containsKey(produto.id)) {
      return;
    }

    final quantidadeAtual =
        _quantidades[produto.id]!;

    if (quantidadeAtual > 1) {
      _quantidades[produto.id] =
          quantidadeAtual - 1;
    } else {
      _quantidades.remove(produto.id);
      _itens.remove(produto);
    }

    notifyListeners();
  }

  void remover(Produto produto) {
    _itens.remove(produto);
    _quantidades.remove(produto.id);

    notifyListeners();
  }

  // EXERCÍCIO 02
  void aplicarCupom(String cupom) {
    if (cupom.trim().toUpperCase() == 'DESCONTO10') {
      _cupomAplicado = true;
      notifyListeners();
    }
  }

  void limparCupom() {
    _cupomAplicado = false;
    notifyListeners();
  }

  void limpar() {
    _itens.clear();
    _quantidades.clear();
    _cupomAplicado = false;

    notifyListeners();
  }
}