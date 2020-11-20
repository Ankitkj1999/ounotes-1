

import 'dart:convert';

import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/app/logger.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:stacked_services/stacked_services.dart';

Logger log = getLogger("AnalyticsService");
@lazySingleton
class AnalyticsService{

  DialogService _dialogService = locator<DialogService>();

  final FirebaseAnalytics analytics = FirebaseAnalytics();  
  

  void logEvent({String name,Map parameters,bool addInNotificationService=false}) async {
    try {
      if (parameters == null)
      {
        analytics.logEvent(name: name);
      }else{
        analytics.logEvent(name: name,parameters: parameters);
      }
      
      if (addInNotificationService && (parameters!=null)){
        OneSignal.shared.sendTags(parameters);
      }
    } on Exception catch (e) {
          log.e("Exception in logging event ${e.toString()}");
    }
  }

  void setUserProperty({String name, String value}) {
    analytics.setUserProperty(name: name, value: value);
  }

  void addTagInNotificationService({String key,dynamic value}){
    OneSignal.shared.sendTag(key, value);
  }

  sendNotification({String id , String title ,String message}) async {
    if (id == null || id.length == 0){
      await _dialogService.showDialog(title: "NO ID",description: "NO ID");
      return;
    }


    var url = "https://onesignal.com/api/v1/notifications";
    var body = json.encode({'app_id':'${DotEnv().env['ONESIGNAL_APP_ID']}', "contents": {"en": message} ,"headings": {"en": title} , "channel_for_external_user_ids": "push","include_external_user_ids": ["$id"]});
    http.Response response = await http.post(
        url,
        headers: {"Content-Type": "application/json","Authorization": "Basic ${DotEnv().env['ONESIGNAL_API_KEY']}"},
        body: body,
      );

      
    // playerID is current users ID but we need the id of the user who reported 
    // var status = await OneSignal.shared.getPermissionSubscriptionState();
    // var playerId = status.subscriptionStatus.userId;
  }
  
}