//
//  MapViewController.h
//  TraveRecord
//
//  Created by 中村 大輔 on 13/11/19.
//  Copyright (c) 2013年 nkmr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "SearchViewController.h"

@interface MapViewController : UIViewController<GMSMapViewDelegate>{
    
    SettingViewController *stgVc;
    SearchViewController *srcVc;
}

@end