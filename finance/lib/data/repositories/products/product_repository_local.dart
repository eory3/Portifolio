import 'package:finance/data/repositories/products/product_repository.dart';
import 'package:finance/domain/models/product.dart';
import 'package:finance/utils/result.dart';

class ProductRepositoryLocal implements IProductRepository {
  @override
  Future<Result<void>> deleteProduct(int id) {
    // TODO: implement deleteProduct
    throw UnimplementedError();
  }

  @override
  Future<Result<List<IProduct>>> getProducts() {
    // TODO: implement getProducts
    throw UnimplementedError();
  }
}
