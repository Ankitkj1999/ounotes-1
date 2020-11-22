
import 'package:FSOUNotes/app/locator.dart';
import 'package:FSOUNotes/services/funtional_services/remote_config_service.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:logger/logger.dart';
import 'package:FSOUNotes/app/logger.dart';

Logger log = getLogger("AdmobService");
@lazySingleton 
class AdmobService{

  RemoteConfigService _remote = locator<RemoteConfigService>();
  String get ADMOB_APP_ID => _remote.remoteConfig.getString("ADMOB_APP_ID");
  String get ADMOB_AD_BANNER_ID => _remote.remoteConfig.getString("ADMOB_AD_BANNER_ID");
  String get ADMOB_AD_INTERSTITIAL_ID => _remote.remoteConfig.getString("ADMOB_AD_INTERSTITIAL_ID");

  BannerAd notes_view_banner_ad;
  InterstitialAd notes_view_interstitial_ad;

  int _NumberOfTimeNotesOpened;
  int _NumberOfAdsShown;

  int get NumberOfTimeNotesOpened => _NumberOfTimeNotesOpened;
  set NumberOfTimeNotesOpened(int value) => _NumberOfTimeNotesOpened = value;
  incrementNumberOfTimeNotesOpened() { if(_NumberOfTimeNotesOpened==null){_NumberOfTimeNotesOpened=0;}_NumberOfTimeNotesOpened++;print(_NumberOfTimeNotesOpened);}
  bool shouldAdBeShown() {
    bool ad =_NumberOfTimeNotesOpened % 5 == 0;
    if (ad){
      if(_NumberOfAdsShown==null){_NumberOfAdsShown=0;}
      _NumberOfAdsShown++;
    } 
    return ad;
  }

  //TODO firebase admob id
  BannerAd getNotesViewBannerAd(){
    return BannerAd(adUnitId:ADMOB_AD_BANNER_ID,size: AdSize.fullBanner);
  }

  InterstitialAd getNotesViewInterstitialAd(){
    return InterstitialAd(adUnitId:ADMOB_AD_INTERSTITIAL_ID);
  }

  showNotesViewBanner(){
    if(notes_view_banner_ad == null ){notes_view_banner_ad = this.getNotesViewBannerAd();}
    notes_view_banner_ad
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  showNotesViewInterstitialAd(){
    if(notes_view_interstitial_ad == null ){notes_view_interstitial_ad = this.getNotesViewInterstitialAd();}
    notes_view_interstitial_ad
      ..load()
      ..show();
  }

  hideNotesViewBanner() async {
    try {
      notes_view_banner_ad?.dispose();
      notes_view_banner_ad = null;
    } catch (ex) {
      log.e("banner dispose error");
    }
  }
  hideNotesViewInterstitialAd() async {
    try {
      notes_view_interstitial_ad?.dispose();
      notes_view_interstitial_ad = null;
    } catch (ex) {
      log.e("Intersitial ad dispose error");
    }
  }
  
}