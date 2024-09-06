import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'bank_wallet_card_platform_interface.dart';

/// An implementation of [BankWalletCardPlatform] that uses method channels.
class MethodChannelBankWalletCard extends BankWalletCardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('bank_wallet_card');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getNativeMessage() async {
    final version =
        await methodChannel.invokeMethod<String>('getNativeMessage');
    return version;
  }

  @override
  Future<void> addPaymentCard(String cardholderName,
      String primaryAccountSuffix, String customerID) async {
    await methodChannel.invokeMethod('addPaymentCard', {
      'cardholderName': cardholderName,
      'primaryAccountSuffix': primaryAccountSuffix,
      'customerId': customerID,
    });
  }

  @override
  Future<void> configureHttp(String baseUrl, String token) async {
    try {
      await methodChannel.invokeMethod('configureHttp', {
        'baseUrl': baseUrl,
        'token': token,
      });
    } on PlatformException catch (e) {
      print("Erro ao configurar HTTP: ${e.message}");
    }
  }
}
