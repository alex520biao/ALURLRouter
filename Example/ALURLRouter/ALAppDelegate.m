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
    
    //登录检查器
    self.urlRouter.interceptor = [ALURLInterceptor interceptorWithId:@"login"
                                                                name:@"interceptorName"
                                                           condition:^BOOL(ALURLEvent *event, ALURLInterceptor *interceptor) {
                                                               
                                                               
                                                               return YES;
                                                           } intercepted:^(ALURLEvent *event, ALURLInterceptor *interceptor) {
                                                               NSLog(@"");
                                                               
                                                               UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"未登录"
                                                                                                                 message:@"当前未登陆请登录之后继续"
                                                                                                                delegate:nil
                                                                                                       cancelButtonTitle:@"OK"
                                                                                                       otherButtonTitles:nil];
                                                               [alertView show];
                                                               
                                                               
                                                               //dispatch计时器
                                                               dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC));
                                                               dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                                                   //拦截器处理完成消息继续分发
                                                                   if(interceptor.goOnBlock){
                                                                       interceptor.goOnBlock(event,interceptor);
                                                                   }
                                                               });
                                                           }];
    
    //根据在注册表创建实例化对象
    __weak typeof(self) weakSelf = self;
    [[ALServiceManager sharedInstance] setupProducts:^(ALBaseService *service) {
        //基础属性依赖注入
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
    
    //接收并处理OpenURL消息(applicationState必须是应用接收到ALURL消息的瞬时状态)
    [self.urlRouter handleOpenURLWithLaunchOptions:launchOptions
                                          userInfo:nil
                                  applicationState:[application applicationState]];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation{

    //接收并处理OpenURL消息(applicationState必须是应用接收到ALURL消息的瞬时状态)
    return [self.urlRouter handleOpenURL:url
                       sourceApplication:sourceApplication
                              annotation:annotation
                                    temp:NO
                                moreInfo:nil
                        applicationState:[application applicationState]];
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
