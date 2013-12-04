//
//  MapViewController.m
//  TraveRecord
//
//  Created by 中村 大輔 on 13/11/19.
//  Copyright (c) 2013年 nkmr. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController (){

    float selectedLatitude;
    float selectedLongitude;
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
    
    // Create a GMSCameraPosition that tells the map to display the default position and default zoom
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:defaultLatitude
                                                            longitude:defaultLongitude
                                                                 zoom:defaultZoom];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    
    mapView_.delegate = self;
    
    mapView_.myLocationEnabled = YES;
    mapView_.indoorEnabled = NO;
    
    self.view = mapView_;

}

- (void)moveMapCenterTo:(float)latitude longitude:(float)longitude zoom:(float)zoom
{
    [mapView_ animateToLocation:CLLocationCoordinate2DMake(latitude, longitude)];
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

- (void)searchSpot:(NSString *)serchText
{
    NSString *isSensorText = @"false";
    NSString *urlAsString = [NSString stringWithFormat:@"%@%@%@%@",URLmain,serchText,URLsensor,isSensorText];
    NSURL *url = [NSURL URLWithString:urlAsString];
    
    NSLog(@"%@",url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSOperationQueue *oQueue = [[NSOperationQueue alloc]init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:oQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
        
        if([data length] > 0 && error == nil){
            
            NSError *error = nil;
            id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
            if(jsonObject != nil && error == nil){
                if([jsonObject isKindOfClass:[NSDictionary class]]){
                    
                    NSDictionary *deserializedDictionary = (NSDictionary *)jsonObject;
                    [self reflectSearch:deserializedDictionary];
                    
                }else
                    if([jsonObject isKindOfClass:[NSArray class]]){
                    
                    //NSArray *deserializedArray = (NSArray *)jsonObject;
                    NSLog(@"Unsupported data was downloaded");
                    
                }else{
                    NSLog(@"Unsupported data was downloaded");
                }
            }
            
        }else if([data length] == 0 && error == nil){
            NSLog(@"Nothing was downloaded");
        }else if(error != nil){
            NSLog(@"Error happend");
        }
    }];
}

- (void)reflectSearch:(NSDictionary *)resultDictionary
{
    NSString *status = [resultDictionary objectForKey:@"status"];
    if([status isEqualToString:@"OK"]){
        
        NSArray *tempArray = [resultDictionary objectForKey:@"results"];
        NSDictionary *tempDic = [tempArray objectAtIndex:0];
        NSString *formatted_address = [tempDic objectForKey:@"formatted_address"];
        NSDictionary *geometry = [tempDic objectForKey:@"geometry"];
        NSDictionary *location = [geometry objectForKey:@"location"];
        NSString *lng = [location objectForKey:@"lng"];
        NSString *lat = [location objectForKey:@"lat"];
        NSLog(@"CREATE NEW MARKER >>> \naddress = %@\nlongitude = %@\nlatitude = %@",formatted_address,lng,lat);
        
        //terminate in main thread
        NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
        [mainQueue addOperationWithBlock:^{
            [self createMarker:CLLocationCoordinate2DMake(lat.floatValue, lng.floatValue) title:formatted_address showAnimation:YES];
            [self moveMapCenterTo:lat.floatValue longitude:lng.floatValue zoom:defaultZoom];
        }];
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    [self showSpotInfoView];
}

- (void)showSpotInfoView
{
    SpotInfoViewController *siv = [[SpotInfoViewController alloc]init];
    [self presentViewController:siv animated:YES completion:nil];
}

- (void)dismissSpotInfoView
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
