//
//  Service.m
//  ALURLManager
//
//  Created by alex520biao on 16/4/25.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "DCMarketingService.h"
#import "ALAppDelegate.h"
#import <ALURLRouter/ALURLRouterKit.h>

@implementation DCMarketingService

- (instancetype)init
{
    self = [super init];
    if (self) {
        //拦截并监听https协议的URL
        [ALURLRouter registerURLPattern:@"https://"
                                handler:^id(ALURLEvent *event, NSError *__autoreleasing *error) {

                                    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"打开https页面"
                                                                                      message:[event.url absoluteString]
                                                                                     delegate:nil
                                                                            cancelButtonTitle:nil
                                                                            otherButtonTitles:@"OK", nil];
                                    [alertView show];
                                    return nil;
                                }];

        //拦截并监听http协议的URL
        [ALURLRouter registerURLPattern:@"http://xiaojukeji.com/"
                                handler:^id(ALURLEvent *event, NSError *__autoreleasing *error) {
                                    
                                    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"打开https页面"
                                                                                      message:[event.url absoluteString]
                                                                                     delegate:nil
                                                                            cancelButtonTitle:nil
                                                                            otherButtonTitles:@"OK", nil];
                                    [alertView show];
                                    return nil;
                                }];
        //异步处理运营通用web页
        [ALURLRouter registerURLPattern:@"app://identifier/marketing"
                                handler:^id(ALURLEvent *event, NSError *__autoreleasing *error) {
                                   
                                   //异步处理运营通用web页
                                   if([event.servie isEqualToString:@"marketing"] && [event.action isEqualToString:@"webpage"]){
                                       
                                       UIViewController *webVC = [[UIViewController alloc] init];
                                       webVC.view.backgroundColor = [UIColor whiteColor];
                                       ALAppDelegate *delegate = (ALAppDelegate*)[UIApplication sharedApplication].delegate;
                                       
                                       [delegate.window.rootViewController presentViewController:webVC
                                                                                        animated:YES
                                                                                      completion:^{
                                                                                          
                                                                                      }];
                                       
                                       //处理中
                                       if (event.progress) {
                                           NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                           [dict setObject:@"进度50%" forKey:@"descr"];
                                           event.progress(event,0.5,dict);
                                       }
                                       
                                       //此服务已不可用
                                       if([[event.queryDict objectForKey:@"error"] integerValue]==1){
                                           *error = [NSError errorWithDomain:ALURLErrorDomain
                                                                        code:403
                                                                    userInfo:nil];
                                       }
                                       
                                       //事件处理完成回调
                                       if (event.completion) {
                                           event.completion(event,@"运营webpage已展示",*error);
                                       }
                                       
                                       //如果URL为同步处理过程则需要返回值
                                       return nil;
                                   }
                                   //异步处理运营通用alert页
                                   else if([event.servie isEqualToString:@"marketing"] && [event.action isEqualToString:@"alert"]){
                                       
                                       UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"运营弹框"
                                                                                         message:nil
                                                                                        delegate:nil
                                                                               cancelButtonTitle:nil
                                                                               otherButtonTitles:@"OK", nil];
                                       [alertView show];
                                       
                                       //处理中
                                       if (event.progress) {
                                           NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                           [dict setObject:@"进度50%" forKey:@"descr"];
                                           event.progress(event,0.5,dict);
                                       }
                                       
                                       //此服务已不可用
                                       if([[event.queryDict objectForKey:@"error"] integerValue]==1){
                                           *error = [NSError errorWithDomain:ALURLErrorDomain
                                                                        code:403
                                                                    userInfo:nil];
                                       }
                                       
                                       //事件处理完成回调
                                       if (event.completion) {
                                           event.completion(event,@"已处理完成",*error);
                                       }
                                       
                                       //如果URL为同步处理过程则需要返回值
                                       return nil;
                                   }

                                   return nil;
                               }];
    }
    return self;
}


@end
