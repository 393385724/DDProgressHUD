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
    _dataSource = @[@"无蒙层darkStyle圆弧Loading",@"钟表Loading",@"成功Alter",@"失败Alter",@"文字Alter"];
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
    if ([title isEqualToString:@"无蒙层darkStyle圆弧Loading"]) {
        [DDProgressHUD setDefaultStyle:DDProgressHUDStyleDark];
        [DDProgressHUD setDefaultMaskStyle:DDProgressHUDMaskStyleNone];
        [DDProgressHUD setDefaultTintColor:[UIColor whiteColor]];
        [DDProgressHUD showHUDWithStatus:@"圆弧Loading多一些文字多一行内容你能看出来的哈哈哈哈哈哈哈"];
        [DDProgressHUD dismissWithDelay:3 completion:^{
            NSLog(@"消失");
        }];
    } else if ([title isEqualToString:@"钟表Loading"]){
        [DDProgressHUD setDefaultStyle:DDProgressHUDStyleLight];
        [DDProgressHUD setDefaultMaskStyle:DDProgressHUDMaskStyleCustom];
        [DDProgressHUD setDefaultTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.84]];
        [DDProgressHUD showClockWithStatus:@"钟表Loading"];
        [DDProgressHUD dismissWithDelay:3 completion:^{
            NSLog(@"钟表消失");
        }];
    } else if ([title isEqualToString:@"成功Alter"]){
        [DDProgressHUD setDefaultMaskStyle:DDProgressHUDMaskStyleNone];
        [DDProgressHUD showSucessWithStatus:@"成功Alter"];
    } else if ([title isEqualToString:@"失败Alter"]){
        [DDProgressHUD setDefaultMaskStyle:DDProgressHUDMaskStyleNone];
        [DDProgressHUD showErrorWithStatus:@"失败Alter"];
    } else if ([title isEqualToString:@"文字Alter"]){
        [DDProgressHUD setDefaultMaskStyle:DDProgressHUDMaskStyleNone];
        [DDProgressHUD showWithStatus:@"文字Alter"];
    }
}


@end
