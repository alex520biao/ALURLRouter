//
//  ALAppDelegate.h
//  ALURLRouter
//
//  Created by alex520biao on 04/27/2016.
//  Copyright (c) 2016 alex520biao. All rights reserved.
//

@import UIKit;
#import "ALMarketingService.h"
#import "ALServiceA.h"
#import "ALServiceB.h"
#import "ALServiceC.h"


@interface ALAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/*!
 *  @brief 底层导航控制器
 */
@property (strong, nonatomic) UINavigationController *naviController;

@property (strong, nonatomic) ALMarketingService *service;
@property (strong, nonatomic) ALServiceA *serviceA;
@property (strong, nonatomic) ALServiceB *serviceB;
@property (strong, nonatomic) ALServiceC *serviceC;

/*!
 *  @brief 业务模块间通信路由(Service间URL调用)
 */
@property(nonatomic,strong)ALURLRouter *urlRouter;



@end
