import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/data/repositories/auth/auth_repository.dart';
import 'package:finance/data/repositories/auth/auth_repository_imp.dart';
import 'package:finance/data/repositories/products/product_repository.dart';
import 'package:finance/data/repositories/products/product_repository_remote.dart';
import 'package:finance/data/repositories/transaction/transaction_repository.dart';
import 'package:finance/data/repositories/transaction/transaction_repository_imp.dart';
import 'package:finance/data/services/api/auth/auth_api_service.dart';
import 'package:finance/data/services/api/auth/auth_service.dart';
import 'package:finance/data/services/api/product/product_api_client.dart';
import 'package:finance/data/services/api/product/product_service.dart';
import 'package:finance/data/services/api/transaction/transaction_api_service.dart';
import 'package:finance/data/services/api/transaction/transaction_service.dart';
import 'package:finance/data/services/config/local_data_service.dart';
import 'package:finance/data/services/config/shared_preferences_service.dart';
import 'package:finance/data/services/local/auth/auth_local.dart';
import 'package:finance/data/services/local/auth/auth_local_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  return [
    // Firebase
    Provider<FirebaseAuth>(create: (context) => FirebaseAuth.instance),
    Provider<FirebaseFirestore>(
      create: (context) => FirebaseFirestore.instance,
    ),

    // Local Service
    Provider<ILocalDataService>(create: (context) => LocalDataService()),

    // Auth
    Provider<IAuthService>(
      create:
          (context) => AuthApiService(
            firebaseAuth: context.read<FirebaseAuth>(),
            firebaseFirestore: context.read<FirebaseFirestore>(),
          ),
    ),
    Provider<IAuthLocalService>(
      create:
          (context) => AuthLocalService(
            localDataService: context.read<ILocalDataService>(),
          ),
    ),
    ChangeNotifierProvider<IAuthRepository>(
      create:
          (context) => AuthRepository(
            authService: context.read<IAuthService>(),
            authLocalService: context.read<IAuthLocalService>(),
          ),
    ),

    // Product
    Provider<IProductService>(create: (context) => ProductApiService()),
    Provider<IProductRepository>(
      create:
          (context) => ProductRepository(
            productService: context.read<IProductService>(),
          ),
    ),

    // Transaction
    Provider<ITransactionService>(
      create:
          (context) => TransactionApiService(
            firebaseAuth: context.read<FirebaseAuth>(),
            firestore: context.read<FirebaseFirestore>(),
          ),
    ),
    Provider<ITransactionRepository>(
      create:
          (context) => TransactionRepository(
            transactionService: context.read<ITransactionService>(),
          ),
    ),
  ];
}
