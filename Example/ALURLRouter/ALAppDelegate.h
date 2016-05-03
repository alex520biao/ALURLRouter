//
//  ALAppDelegate.h
//  ALURLRouter
//
//  Created by alex520biao on 04/27/2016.
//  Copyright (c) 2016 alex520biao. All rights reserved.
//

@import UIKit;
#import "DCMarketingService.h"
#import "ServiceA.h"
#import "ServiceB.h"


@interface ALAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*!
 *  @brief 底层导航控制器
 */
@property (strong, nonatomic) UINavigationController *naviController;

@property (strong, nonatomic) DCMarketingService *service;
@property (strong, nonatomic) ServiceA *serviceA;
@property (strong, nonatomic) ServiceB *serviceB;


@end
