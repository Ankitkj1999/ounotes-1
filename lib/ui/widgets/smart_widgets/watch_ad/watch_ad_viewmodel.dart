import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
import 'package:FSOUNotes/enums/bottom_sheet_type.dart';
import 'package:FSOUNotes/services/funtional_services/admob_service.dart';
import 'package:FSOUNotes/services/funtional_services/google_in_app_payment_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
Logger log = getLogger("WatchAdToContinueViewModel");
class WatchAdToContinueViewModel extends BaseViewModel {
  AdmobService _admobService = locator<AdmobService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  NavigationService _navigationService = locator<NavigationService>();
  GoogleInAppPaymentService _googleInAppPaymentService = locator<GoogleInAppPaymentService>();

  buyPremium() async {
    ProductDetails prod = _googleInAppPaymentService.getProduct(GoogleInAppPaymentService.premiumProductID);
    if(prod == null)return;

    SheetResponse response = await _bottomSheetService.showCustomSheet(
      title: "OU Notes Premium",
      variant: BottomSheetType.premium,
      customData: {"price" : prod.price}
    );
    if(response?.confirmed ?? false){
      if(prod == null){return;}
      await _googleInAppPaymentService.buyProduct(prod:prod);
      log.e("Download started");
    }
  }

  showAd() async {
    //TODO implement show ads
    // await _admobService.watchAdNow();
    // if(_admobService.adDue && !_admobService.adShown)await _admobService.showInterstitialAd();
    // await Future.delayed(Duration(seconds: 1));
    // _navigationService.popRepeated(1);

  }
}
