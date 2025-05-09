import 'package:finance/data/repositories/products/product_repository.dart';
import 'package:finance/data/services/api/product/product_service.dart';
import 'package:finance/domain/models/product.dart';
import 'package:finance/utils/result.dart';

class ProductRepository implements IProductRepository {
  final IProductService _productService;

  ProductRepository({required IProductService productService})
    : _productService = productService;

  @override
  Future<Result<List<IProduct>>> getProducts() async {
    try {
      final result = await _productService.getProducts();

      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }

  @override
  Future<Result<void>> deleteProduct(int id) async {
    try {
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e.toString());
    }
  }
}
