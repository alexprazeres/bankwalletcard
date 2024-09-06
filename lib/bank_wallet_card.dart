// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'bank_wallet_card_platform_interface.dart';

class BankWalletCard {
  Future<String?> getPlatformVersion() {
    return BankWalletCardPlatform.instance.getPlatformVersion();
  }

  Future<String?> getNativeMessage() {
    return BankWalletCardPlatform.instance.getNativeMessage();
  }

  Future<void> addPaymentCard(String cardholderName,
      String primaryAccountSuffix, String customerID) async {
    return BankWalletCardPlatform.instance
        .addPaymentCard(cardholderName, primaryAccountSuffix, customerID);
  }

  Future<void> configureHttp(String baseUrl, String token) {
    return BankWalletCardPlatform.instance.configureHttp(baseUrl, token);
  }
}
