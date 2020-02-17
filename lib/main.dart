import 'package:flutter/material.dart';

class Product {
  // voidのhomeに返すためのクラス
  const Product({this.name});
  // nameという引数を持った定数を宣言
  final String name;
  // String型、「name」の変数宣言・initialize
}

typedef void CartChangedCallback(Product product, bool inCart);
// 型の宣言　productはProduct型、inCartはbool型（true,false）

class ShoppingListItem extends StatelessWidget {
  // リストの中身を定義したクラス
  // 静的なwidgetを持つ
  ShoppingListItem({this.product, this.inCart, this.onCartChanged})
      : super(key: ObjectKey(product));
  // クラスの引数を定義
  // product（変数）、inCart(true,false)、タップ通知の値を持つ

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;
  // 変数の宣言

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different parts of the tree
    // can have different themes.  The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return inCart ? Colors.black54 : Theme.of(context).primaryColor;
  }
  // タップ時にサークルアバターの色を黒くするメソッド

  TextStyle _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }
  // タップ時にテキストに見え消し線を追加するメソッド

  @override
  Widget build(BuildContext context) {
    // ShoppingListItemのbuild（何を表示させるか）
    return ListTile(
      onTap: () {
        onCartChanged(product, inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(product.name, style: _getTextStyle(context)),
    );
    // タップ可能なリストを作成
    // 円形のアバター（これだけで先頭文字のみ取得する仕様となっている）と_getColorメソッドを引数として定義
    // リストのタイトルにproduct名とgetTextStyleメソッドを引数として定義
  }
}


class ShoppingList extends StatefulWidget {
  ShoppingList({Key key, this.products}) : super(key: key);

  final List<Product> products;
  // Product型のリストを宣言
  // The framework calls createState the first time a widget appears at a given
  // location in the tree. If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses the State object
  // instead of creating a new State object.

  @override
  _ShoppingListState createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  Set<Product> _shoppingCart = Set<Product>();

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      // When a user changes what's in the cart, you need to change
      // _shoppingCart inside a setState call to trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      if (!inCart)
        _shoppingCart.add(product);
      else
        _shoppingCart.remove(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((Product product) {
          return ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Shopping App',
    home: ShoppingList(
      products: <Product>[
        Product(name: 'Eggs'),
        Product(name: 'Flour'),
        Product(name: 'Chocolate chips'),
      ],
    ),
  ));
}
