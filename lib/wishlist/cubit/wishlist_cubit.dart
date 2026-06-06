import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';

part 'wishlist_state.dart';

/// Stores wishlist as an array on the user document for simplicity.
class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit({
    required FirebaseFirestore firestore,
    required ProductRepository productRepository,
  }) : _firestore = firestore,
       _productRepository = productRepository,
       super(const WishlistState());

  final FirebaseFirestore _firestore;
  final ProductRepository _productRepository;

  Future<void> loadWishlist(String userId) async {
    emit(state.copyWith(status: WishlistStatus.loading));
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      final ids = List<String>.from(
        doc.data()?['wishlistIds'] as List? ?? [],
      );
      if (ids.isEmpty) {
        emit(state.copyWith(status: WishlistStatus.success, productIds: ids));
        return;
      }
      final products = await Future.wait(
        ids.map(_productRepository.getProduct),
      );
      emit(
        state.copyWith(
          status: WishlistStatus.success,
          productIds: ids,
          products: products.whereType<Product>().toList(),
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: WishlistStatus.failure));
    }
  }

  Future<void> toggleWishlist({
    required String userId,
    required Product product,
  }) async {
    final ids = [...state.productIds];
    final products = [...state.products];
    final isWishlisted = ids.contains(product.id);

    if (isWishlisted) {
      ids.remove(product.id);
      products.removeWhere((p) => p.id == product.id);
    } else {
      ids.add(product.id);
      products.add(product);
    }

    emit(state.copyWith(productIds: ids, products: products));

    try {
      await _firestore.collection('users').doc(userId).update({
        'wishlistIds': ids,
      });
    } catch (_) {
      // Revert on failure.
      await loadWishlist(userId);
    }
  }

  bool isWishlisted(String productId) => state.productIds.contains(productId);
}
