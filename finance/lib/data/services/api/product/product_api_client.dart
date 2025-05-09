import 'package:finance/data/services/api/product/product_service.dart';
import 'package:finance/data/services/models/product.dart';
import 'package:finance/domain/models/product.dart';

class ProductApiService implements IProductService {
  @override
  Future<void> deleteProduct(int id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<List<IProduct>> getProducts() {
    return Future.value([
      Product(
        id: 1,
        name: 'Produto 1',
        price: 10.0,
        image: 'https://placehold.co/600x400/png',
      ),
      Product(
        id: 2,
        name: 'Produto 2',
        price: 20.0,
        image: 'https://placehold.co/600x400/png',
      ),
      Product(
        id: 3,
        name: 'Produto 3',
        price: 30.0,
        image: 'https://placehold.co/600x400/png',
      ),
    ]);
  }
}
