import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'bank_wallet_card_method_channel.dart';

abstract class BankWalletCardPlatform extends PlatformInterface {
  /// Constructs a BankWalletCardPlatform.
  BankWalletCardPlatform() : super(token: _token);

  static final Object _token = Object();

  static BankWalletCardPlatform _instance = MethodChannelBankWalletCard();

  /// The default instance of [BankWalletCardPlatform] to use.
  ///
  /// Defaults to [MethodChannelBankWalletCard].
  static BankWalletCardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [BankWalletCardPlatform] when
  /// they register themselves.
  static set instance(BankWalletCardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getNativeMessage() {
    throw UnimplementedError('getNativeMessage() has not been implemented.');
  }

  Future<void> addPaymentCard(String cardholderName,
      String primaryAccountSuffix, String customerID) async {
    throw UnimplementedError('addPaymentCard() has not been implemented.');
  }

  Future<void> configureHttp(String baseUrl, String token) async {
    throw UnimplementedError('configureHttp() has not been implemented.');
  }
}
