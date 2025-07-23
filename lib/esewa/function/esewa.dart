import'package:esewa_flutter_sdk/esewa_flutter_sdk.dart';
import'package:esewa_flutter_sdk/esewa_config.dart';
import'package:esewa_flutter_sdk/esewa_payment.dart';
import'package:esewa_flutter_sdk/esewa_payment_success_result.dart';
import 'package:flutter/cupertino.dart';

import '../constant/esewa.dart';
class Esewa{
  pay() {
    try {
      EsewaFlutterSdk.initPayment(
        esewaConfig: EsewaConfig(
          environment: Environment.test,
          clientId: KEsewaClientId,
          secretId: KEsewaSecretKey,
        ),
        esewaPayment: EsewaPayment(
          productId: "1d71jd81",
          productName: "Product One",
          productPrice: "50",
          callbackUrl: '',
        ),
        onPaymentSuccess: (EsewaPaymentSuccessResult result) {
          debugPrint('SUCCESS');
          verify(result);
        },
        onPaymentFailure: (data) {
          debugPrint('FAILURE');
        },
        onPaymentCancellation: (data) {
          debugPrint('CANCELLATION');
        },
      );
    } catch (e) {
      debugPrint('EXCEPTION');
    }
  }

    verify(EsewaPaymentSuccessResult result) {
// todo:: after success call this function to verify transcaction
    }

}