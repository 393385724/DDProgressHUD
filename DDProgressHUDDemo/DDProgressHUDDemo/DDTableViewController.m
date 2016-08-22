//
//  DDTableViewController.m
//  DDProgressHUD
//
//  Created by lilingang on 16/8/22.
//  Copyright © 2016年 LiLingang. All rights reserved.
//

#import "DDTableViewController.h"
#import "DDProgressHUD.h"

@interface DDTableViewController ()

@end

@implementation DDTableViewController{
    NSArray *_dataSource;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    _dataSource = @[@"圆弧Loading",@"钟表Loading",@"成功Alter",@"失败Alter",@"文字Alter"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = _dataSource[indexPath.row];    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = _dataSource[indexPath.row];
    if ([title isEqualToString:@"圆弧Loading"]) {
        [DDProgressHUD showHUDWithStatus:@"圆弧Loading"];
        [DDProgressHUD dismissWithDelay:5 completion:^{
            NSLog(@"消失");
        }];
    } else if ([title isEqualToString:@"钟表Loading"]){
        [DDProgressHUD showClockWithStatus:@"钟表Loading"];
        [DDProgressHUD dismissWithDelay:5 completion:^{
            NSLog(@"钟表消失");
        }];
    } else if ([title isEqualToString:@"成功Alter"]){
        [DDProgressHUD showSucessWithStatus:@"成功Alter"];
    } else if ([title isEqualToString:@"失败Alter"]){
        [DDProgressHUD showSucessWithStatus:@"失败Alter"];
    } else if ([title isEqualToString:@"文字Alter"]){
        [DDProgressHUD showWithStatus:@"文字Alter"];
    }
}


@end
