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
        [self.urlRouter callInsideURL:@"app://identifier/sercieA/action1/a?orderId=123456&error=0"
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
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:@"ADSDSAD" forKey:@"userId"];
        
        [self.urlRouter callInsideURL:@"app://identifier/marketing/webpage"
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
        
        [self.urlRouter callInsideURL:@"app://identifier/marketing/alert"
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
        [self.urlRouter callInsideURL:@"http://xiaojukeji.com/abc"];
    }else if (action==4){
        //打开http或https协议URL
        [self.urlRouter callInsideURL:@"https://xiaojukeji.com/efg"];
    }
}

@end
