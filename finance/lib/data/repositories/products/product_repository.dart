import 'package:finance/domain/models/product.dart';
import 'package:finance/utils/result.dart';

abstract class IProductRepository {
  Future<Result<List<IProduct>>> getProducts();
  Future<Result<void>> deleteProduct(int id);
}
