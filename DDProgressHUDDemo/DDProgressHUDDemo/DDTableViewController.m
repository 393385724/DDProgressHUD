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
    _dataSource = @[@"Text",
                    @"Sucess",
                    @"Error",
                    @"LineChange",
                    @"NineDots",
                    @"TriplePulse",
                    @"FiveDots",
                    @"RotatingSquares",
                    @"DoubleBounce",
                    @"TwoDots",
                    @"ThreeDots",
                    @"BallPulse",
                    @"BallClipRotate",
                    @"BallClipRotatePulse",
                    @"BallClipRotateMultiple",
                    @"BallRotate",
                    @"BallZigZag",
                    @"BallZigZagDeflect",
                    @"BallTrianglePath",
                    @"BallScale",
                    @"LineScale",
                    @"LineScaleParty",
                    @"BallScaleMultiple",
                    @"BallPulseSync",
                    @"BallBeat",
                    @"LineScalePulseOut",
                    @"LineScalePulseOutRapid",
                    @"BallScaleRipple",
                    @"BallScaleRippleMultiple",
                    @"TriangleSkewSpin",
                    @"BallGridBeat",
                    @"BallGridPulse",
                    @"RotatingSanDDGlass",
                    @"RotatingTrigons",
                    @"TripleRings",
                    @"CookieTerminator",
                    @"BallSpinFadeLoader",
                    @"Clock"];
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
    if (indexPath.row == 0) {
        [DDProgressHUD showWithStatus:@"成功Alter 米动，可以全自动地记录全天活动、睡眠、运动等生活习惯，并根据大量数据分析，提供专业有益的建议，帮助人们生活得更加健康。"];
    } else if (indexPath.row == 1){
        [DDProgressHUD showSucessWithStatus:@"成功Alter 米动，可以全自动地记录全天活动、睡眠、运动等生活习惯，并根据大量数据分析，提供专业有益的建议，帮助人们生活得更加健康。"];
    } else if (indexPath.row == 2){
        [DDProgressHUD showErrorWithStatus:@"无网络,请稍后重试"];
    } else if (indexPath.row >= 3) {
        [DDProgressHUD setDefaultActivityType:indexPath.row - 3];
        [DDProgressHUD showHUDWithStatus:[_dataSource[indexPath.row] stringByAppendingString:@"3秒后消失"]];
        [DDProgressHUD dismissWithDelay:3 completion:^{
            NSLog(@"钟表消失");
        }];
    }
}


@end
