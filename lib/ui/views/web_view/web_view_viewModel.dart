import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:FSOUNotes/app/app.locator.dart';
import 'package:FSOUNotes/app/app.logger.dart';
import 'package:FSOUNotes/app/app.router.dart';
class WebViewModel extends BaseViewModel{
  DialogService _dialogService = locator<DialogService>();
  NavigationService _navigationService = locator<NavigationService>();
  void showDownloadPreventDialog(FlutterWebviewPlugin web)async {
    await web.close();
    await _dialogService.showDialog(title: "WARNING" , description: "Notes cannot be downloaded.");
    _navigationService.popRepeated(1);
  }
}