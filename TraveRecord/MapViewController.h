//
//  MapViewController.h
//  TraveRecord
//
//  Created by 中村 大輔 on 13/11/19.
//  Copyright (c) 2013年 nkmr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Const.h"
#import "SettingViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SearchViewController.h"
#import "SpotInfoViewController.h"

#define searchViewTitle @"スポット検索"
#define addSpotViewTitle  @"スポット追加"

#define URLmain @"http://maps.googleapis.com/maps/api/geocode/json?address="
#define URLsensor @"&sensor="

#define defaultLatitude -33.86
#define defaultLongitude 151.20
#define defaultZoom 10

@protocol SpotInfoDelegate

- (void)editMemo;
- (void)closeSpotInfo;
- (void)searchNextSpot;

@end

@interface MapViewController : UIViewController<GMSMapViewDelegate,SpotInfoDelegate>{
    
    SettingViewController *stgVc;
    SearchViewController *srcVc;
}

@end
