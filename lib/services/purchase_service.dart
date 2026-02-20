import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PurchaseService {
  static const String premiumProductId = 'premium_unlock_59';
  static const String _premiumKey = 'is_premium_user';

  final InAppPurchase _iap = InAppPurchase.instance;

  final ValueNotifier<bool> isPremium = ValueNotifier<bool>(false);
  final ValueNotifier<List<ProductDetails>> products =
      ValueNotifier<List<ProductDetails>>(<ProductDetails>[]);

  StreamSubscription<List<PurchaseDetails>>? _purchaseSubscription;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    isPremium.value = prefs.getBool(_premiumKey) ?? false;

    final available = await _iap.isAvailable();
    if (!available) {
      return;
    }

    final productResponse =
        await _iap.queryProductDetails(<String>{premiumProductId});
    products.value = productResponse.productDetails;

    _purchaseSubscription ??=
        _iap.purchaseStream.listen(_handlePurchaseUpdates);
  }

  Future<void> buyPremium() async {
    if (products.value.isEmpty) {
      return;
    }
    final product = products.value.first;
    final param = PurchaseParam(productDetails: product);
    await _iap.buyNonConsumable(purchaseParam: param);
  }

  Future<void> _handlePurchaseUpdates(
    List<PurchaseDetails> purchaseDetailsList,
  ) async {
    final prefs = await SharedPreferences.getInstance();

    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        isPremium.value = true;
        await prefs.setBool(_premiumKey, true);
      }

      if (purchase.pendingCompletePurchase) {
        await _iap.completePurchase(purchase);
      }
    }
  }

  void dispose() {
    _purchaseSubscription?.cancel();
    isPremium.dispose();
    products.dispose();
  }
}
