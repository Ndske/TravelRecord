//
//  SpotInfoViewController.h
//  TravelRecord
//
//  Created by 中村 大輔 on 13/12/04.
//  Copyright (c) 2013年 nkmr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpotInfoViewController : UIViewController
{
    __weak IBOutlet UILabel *spotname;
    __weak IBOutlet UIImageView *spotImage;
    __weak IBOutlet UITextField *spotMemo;


}
- (IBAction)closeSpotInfoView:(id)sender;
- (IBAction)searchNextSpot:(id)sender;

@end
