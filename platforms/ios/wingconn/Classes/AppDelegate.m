/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

//
//  AppDelegate.m
//  wingconn
//
//  Created by ___FULLUSERNAME___ on ___DATE___.
//  Copyright ___ORGANIZATIONNAME___ ___YEAR___. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "FigerprintUnlock.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    NSString *tmpPath = NSTemporaryDirectory();
    NSLog(@"tmpPath==%@",tmpPath);
    self.viewController = [[MainViewController alloc] init];
    [FigerprintUnlock userFigerprintAuthenticationTisWithStr:@"请把输入指纹的手指放在Home键上" success:^(BOOL success) {
        //成功的回调
    } faild:^(NSInteger code) {
        //失败的回调
        if(code == -1){
            NSLog(@"不支持");
        }
    }];
    [self setup3DTouch:application];
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)setup3DTouch:(UIApplication *)application
{
    /**
     type 该item 唯一标识符
     localizedTitle ：标题
     localizedSubtitle：副标题
     icon：icon图标 可以使用系统类型 也可以使用自定义的图片
     userInfo：用户信息字典 自定义参数，完成具体功能需求
     */
    //    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"标签.png"];
    UIApplicationShortcutIcon *cameraIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
    UIApplicationShortcutItem *cameraItem = [[UIApplicationShortcutItem alloc] initWithType:@"ONE" localizedTitle:@"拍照" localizedSubtitle:@"" icon:cameraIcon userInfo:nil];
    
    UIApplicationShortcutIcon *shareIcon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeShare];
    UIApplicationShortcutItem *shareItem = [[UIApplicationShortcutItem alloc] initWithType:@"TWO" localizedTitle:@"分享" localizedSubtitle:@"" icon:shareIcon userInfo:nil];
    /** 将items 添加到app图标 */
    application.shortcutItems = @[cameraItem,shareItem];
}
-(void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    
    if([shortcutItem.type isEqualToString:@"ONE"]){
       
    }else if ([shortcutItem.type isEqualToString:@"TWO"]){
       
    }
}
@end
