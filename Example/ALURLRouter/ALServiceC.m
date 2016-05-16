//
//  ServiceC.m
//  ALURLRouter
//
//  Created by alex520biao on 16/5/5.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ALServiceC.h"
#import "ALServiceManager.h"

@implementation ALServiceC

+(void)load{
    [[ALServiceManager sharedInstance] addService:[self class]
                                        serviceId:@"ALServiceC"];
}

-(void)handleUserAction:(NSInteger)action{
    
    if (action==0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"ADSDSAD" forKey:@"userId"];
        
        NSURL *URL = [NSURL URLWithString:@"alex://com.alex.ALURLRouter-Example/sercieA/action1/a?orderId=123456&error=0"];
        [self.urlRouter callInsideURL:URL
                      withUserInfo:dict
                          progress:^(ALURLEvent *event, ALProgress progress, NSDictionary *moreInfo) {
                              NSLog(@"progress");
                          } completed:^(ALURLEvent *event, id result, NSError *error) {
                              NSLog(@"completed");
                              
                              //执行成功
                              if(!error){
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异步InsideURL: 成功"
                                                                                  message:[NSString stringWithFormat:@"返回值:%@",result]
                                                                                 delegate:nil
                                                                        cancelButtonTitle:nil
                                                                        otherButtonTitles:@"OK", nil];
                                  [alert show];
                              }
                              //发生异常
                              else{
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"同步InsideURL: 失败"
                                                                                  message:[NSString stringWithFormat:@"error:%@",[error description]]
                                                                                 delegate:nil
                                                                        cancelButtonTitle:nil
                                                                        otherButtonTitles:@"OK", nil];
                                  [alert show];
                              }
                          }];

    }else if (action==1){
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        [userInfo setObject:@"ADSDSAD" forKey:@"userId"];
        
        NSURL *URL = [NSURL URLWithString:@"alex://com.alex.ALURLRouter-Example/marketing/webpage?weburl=http%3a%2f%2fwww.hao123.com%2f"];
        [self.urlRouter callInsideURL:URL
                      withUserInfo:userInfo
                          progress:^(ALURLEvent *event, ALProgress progress, NSDictionary *moreInfo) {
                              NSLog(@"progress");
                          } completed:^(ALURLEvent *event, id result, NSError *error) {
                              NSLog(@"completed");
                              
                              //执行成功
                              if(!error){
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异步InsideURL: 成功"
                                                                                  message:[NSString stringWithFormat:@"返回值:%@",result]
                                                                                 delegate:nil
                                                                        cancelButtonTitle:nil
                                                                        otherButtonTitles:@"OK", nil];
                                  [alert show];
                              }
                              //发生异常
                              else{
                                  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异步InsideURL: 失败"
                                                                                  message:[NSString stringWithFormat:@"error:%@",[error description]]
                                                                                 delegate:nil
                                                                        cancelButtonTitle:nil
                                                                        otherButtonTitles:@"OK", nil];
                                  [alert show];
                              }
                          }];
    }else if (action==2){
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"ADSDSAD" forKey:@"userId"];
        
        NSURL *URL = [NSURL URLWithString:@"alex://com.alex.ALURLRouter-Example/marketing/alert"];
        [self.urlRouter callInsideURL:URL
                      withUserInfo:dict
                          progress:^(ALURLEvent *event, ALProgress progress, NSDictionary *moreInfo) {
                              NSLog(@"progress");
                          } completed:^(ALURLEvent *event, id result, NSError *error) {
                              NSLog(@"completed");
                              
                              //执行成功
                              if(!error){
                                  //...
                              }
                              //发生异常
                              else{
                                  //...
                              }
                          }];
    }else if (action==3){
        //打开http或https协议URL
        [self.urlRouter callInsideURL:[NSURL URLWithString:@"http://xiaojukeji.com/abc"]];
    }else if (action==4){
        //打开http或https协议URL
        [self.urlRouter callInsideURL:[NSURL URLWithString:@"https://xiaojukeji.com/efg"]];
    }
}

@end
