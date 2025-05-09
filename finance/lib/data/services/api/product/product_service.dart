import 'package:finance/domain/models/product.dart';

abstract class IProductService {
  Future<List<IProduct>> getProducts();
  Future<void> deleteProduct(int id);
}
