import 'package:esewa_flutter_sdk/esewa_config.dart';
import 'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import 'package:esewa_flutter_sdk/esewa_payment.dart';
import 'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../constant/esewa.dart';

class Esewa {
  pay({
    required String productId,
    required String productName,
    required String productPrice,
    required VoidCallback onSuccess,
  }) {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: KEsewaClientId,
          secretId: KEsewaSecretKey,
        ),
        esewaPayment: EsewaPayment(
          productId: productId,
          productName: productName,
          productPrice: productPrice,
          callbackUrl: 'https://example.com/callback',
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult result) {
          debugPrint('eSewa SUCCESS: ${result.refId}');
          Get.snackbar('Payment Successful', 'Ref ID: ${result.refId}');
          onSuccess(); // 👉 Trigger order process
          verify(result); // Optional
        },
        onPaymentFailure: (data) {
          debugPrint('eSewa FAILURE');
          Get.snackbar('Payment Failed', 'Try again.');
        },
        onPaymentCancellation: (data) {
          debugPrint('eSewa CANCELLED');
          Get.snackbar('Payment Cancelled', 'Transaction was cancelled.');
        },
      );
    } catch (e) {
      debugPrint('eSewa EXCEPTION: $e');
      Get.snackbar('Payment Error', 'An error occurred.');
    }
  }

  verify(EsewaPaymentSuccessResult result) {
    // Optional: call your backend to verify
  }
}
