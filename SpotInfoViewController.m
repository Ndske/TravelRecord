//
//  SpotInfoViewController.m
//  TravelRecord
//
//  Created by 中村 大輔 on 13/12/04.
//  Copyright (c) 2013年 nkmr. All rights reserved.
//

#import "SpotInfoViewController.h"

@interface SpotInfoViewController ()
{
    NSString *spotNameText;
}
@end

@implementation SpotInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [spotName setText:spotNameText];
}

- (void)spotName:(NSString *)name
{
    spotNameText = name;
}

- (IBAction)closeSpotInfoView:(id)sender {
}

- (IBAction)searchNextSpot:(id)sender {
}
@end
