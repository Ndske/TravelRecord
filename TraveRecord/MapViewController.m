//
//  MapViewController.m
//  TraveRecord
//
//  Created by 中村 大輔 on 13/11/19.
//  Copyright (c) 2013年 nkmr. All rights reserved.
//

#import "MapViewController.h"
#import "Const.h"

@interface MapViewController (){

    float selectedLatitude;
    float selectedLongitude;
    HttpConnection *conn;
}

@end

@implementation MapViewController{
 
    GMSMapView *mapView_;
}

- (id)init
{
    self = [super init];
    if(self){
        
        //Title
        self.title = appTitle;
    
        //Right Button
        UIBarButtonItem *rbbi = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Setting"
                                 style:UIBarButtonItemStyleBordered
                                 target:self action:@selector(showSettingView:)];
        //Left Button
        UIBarButtonItem *lbbi = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Search"
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(showSearchView:)];
        
        
        
        //NavigationBar
        self.navigationItem.rightBarButtonItem = rbbi;
        self.navigationItem.leftBarButtonItem = lbbi;
    }
    return self;
}

- (void)viewDidLoad
{
    
//    [super viewDidLoad];
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView_.delegate = self;
    
    mapView_.myLocationEnabled = YES;
    mapView_.indoorEnabled = NO;
    
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    [self createMarker:CLLocationCoordinate2DMake(-33.86, 151.20) title:@"Sydney" showAnimation:YES];

    [self createMarker:CLLocationCoordinate2DMake(-34, 152) title:@"22" showAnimation:YES];
}

- (void)showSettingView:(id)sender
{
    stgVc = [[SettingViewController alloc]init];
    [self.navigationController pushViewController:stgVc animated:YES];
}

- (void)showSearchView:(id)sender
{
    srcVc = [[SearchViewController alloc]init];
    UIAlertView *search = [[UIAlertView alloc]
                           initWithTitle:searchViewTitle
                           message:@"探す場所の住所を入力してください"
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           otherButtonTitles:@"Search", nil];
    [search setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [search show];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    selectedLatitude = coordinate.latitude;
    selectedLongitude = coordinate.longitude;
    [self showAlertView];

}

- (void) showAlertView
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:addSpotViewTitle
                          message:@"この場所に追加しますか？"
                          delegate:self
                          cancelButtonTitle:@"Cancel"
                          otherButtonTitles:@"Add Marker", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if([alertView.title isEqualToString:searchViewTitle]){
        
        switch (buttonIndex) {
            case 1:
                [self searchSpot:[[alertView textFieldAtIndex:0]text]];
                break;
                
            default:
                break;
        }
    }else if([alertView.title isEqualToString:addSpotViewTitle]){
        switch (buttonIndex) {
            case 1:
                [self createMarker:CLLocationCoordinate2DMake(selectedLatitude, selectedLongitude) title:@"Title" showAnimation:YES];
                break;
                
            default:
                break;
        }
    }
}

- (NSString *)searchSpot:(NSString *)serchText
{
    NSLog(@"%@",serchText);
    conn = [[HttpConnection alloc]init];
    [conn getAddressJson:serchText sensor:NO];
    return @"";
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    NSLog(@"InfoWindow");
}

- (GMSMarker *)createMarker:(CLLocationCoordinate2D) coord title:(NSString*)title showAnimation:(BOOL)showAnimation
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coord;
    marker.title = title;
    marker.map = mapView_;
    
    
    if(showAnimation){
        marker.appearAnimation = kGMSMarkerAnimationPop;
    }
    return  marker;
}

- (GMSMarker *)createMarker:(CLLocationCoordinate2D) coord title:(NSString *)title showAnimation:(BOOL)showAnimation color:(UIColor*)color
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coord;
    marker.title = title;
    marker.map = mapView_;
    marker.icon = [GMSMarker markerImageWithColor:color];
    if(showAnimation){
        marker.appearAnimation = kGMSMarkerAnimationPop;
    }
    return  marker;
}

- (GMSMarker *)createMarker:(CLLocationCoordinate2D) coord title:(NSString *)title showAnimation:(BOOL)showAnimation image:(UIImage*)image
{
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = coord;
    marker.title = title;
    marker.map = mapView_;
    marker.icon = image;
    if(showAnimation){
        marker.appearAnimation = kGMSMarkerAnimationPop;
    }
    return  marker;
}

@end
