//
//  SettingViewController.m
//  TraveRecord
//
//  Created by 中村 大輔 on 13/11/19.
//  Copyright (c) 2013年 nkmr. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"Seeting";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    rowArray = [[NSArray alloc]initWithObjects:@"Setting1",@"Setting2", nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [rowArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"SettingTable";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [rowArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SELECTED: %@ ",[rowArray objectAtIndex:indexPath.row]);
}

@end
