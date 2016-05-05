//
//  ALAppDelegate.m
//  ALURLRouter
//
//  Created by alex520biao on 04/27/2016.
//  Copyright (c) 2016 alex520biao. All rights reserved.
//

#import "ALAppDelegate.h"
#import "ALViewController.h"
#import <ALURLRouter/ALURLRouterKit.h>
#import "ALServiceManager.h"

@interface ALAppDelegate ()

/*!
 *  @brief 业务模块间通信路由(Service间URL调用)
 */
//@property(nonatomic,strong)ALURLRouter *urlRouter;

@end

@implementation ALAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    ALViewController *mainViewController = [[ALViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    nav.navigationBarHidden = YES;//是否隐藏导航栏
    nav.navigationBar.barStyle = UIBarStyleBlack;
    self.naviController = nav;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    self.urlRouter = [[ALURLRouter alloc] init];
    
    //根据在注册表创建实例化对象
    __weak typeof(self) weakSelf = self;
    [[ALServiceManager sharedInstance] setupProducts:^(ALBaseService *service) {
        //属性依赖注入
        service.urlRouter = weakSelf.urlRouter;
        
        if([service isKindOfClass:[ALMarketingService class]]){
            self.service = (ALMarketingService*)service;
        }else if ([service isKindOfClass:[ALServiceA class]]){
            self.serviceA = (ALServiceA*)service;
        }else if([service isKindOfClass:[ALServiceB class]]){
            self.serviceB = (ALServiceB*)service;
        }else if([service isKindOfClass:[ALServiceC class]]){
            self.serviceC = (ALServiceC*)service;
        }
    }];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
