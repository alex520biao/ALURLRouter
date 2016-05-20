//
//  Service.m
//  ALURLManager
//
//  Created by alex520biao on 16/4/25.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ALMarketingService.h"
#import "ALAppDelegate.h"
#import <ALURLRouter/ALURLRouterKit.h>

#import "PXAlertView.h"
#import "ALDetailViewController.h"
#import "ALWebViewController.h"

#import "ALServiceManager.h"

@implementation ALMarketingService


+(void)load{

    [[ALServiceManager sharedInstance] addService:[self class] serviceId:@"ALMarketingService"];
}

-(void)serviceDidLoad{
    [super serviceDidLoad];

    //拦截并监听http协议的URL
    [self.urlRouter registerURLPattern:@"http://"
                               handler:^id(ALURLEvent *event, NSError *__autoreleasing *error) {
                                   //使用系统Safari浏览器打开http页面
                                   [PXAlertView showAlertWithTitle:@"使用系统Safari浏览器打开http页面"
                                                           message:[event.url absoluteString]
                                                       cancelTitle:@"OK"
                                                        completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                            //http页面前往系统浏览器
                                                            NSURL *url = [NSURL URLWithString:[event.url absoluteString]];
                                                            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                                                                [[UIApplication sharedApplication] openURL:url];
                                                            }
                                                        }];
                                   return nil;
                               }];
    
    //拦截并监听https协议的URL(可以是应用内浏览器页面)
    [self.urlRouter registerURLPattern:@"https://"
                               handler:^id(ALURLEvent *event, NSError *__autoreleasing *error) {
                                   //使用native页面打开https页面
                                   [PXAlertView showAlertWithTitle:@"拦截https页面转换为native页面"
                                                           message:[event.url absoluteString]
                                                       cancelTitle:@"OK"
                                                        completion:^(BOOL cancelled, NSInteger buttonIndex) {
                                                            ALDetailViewController *detailViewController = [[ALDetailViewController alloc] init];
                                                            detailViewController.title = [NSString stringWithFormat:@"https页面转化而来:%@",[event.url absoluteString]];
                                                            ALAppDelegate *delegate =[UIApplication sharedApplication].delegate;
                                                            [delegate.naviController pushViewController:detailViewController
                                                                                               animated:YES];
                                                            
                                                        }];
                                   return nil;
                               }];
    
    
    //异步处理运营通用web页
    [self.urlRouter registerURLPattern:@"alex://com.alex.ALURLRouter-Example/marketing"
                               handler:^id(ALURLEvent *event, NSError *__autoreleasing *error) {
                                   
                                   //异步处理运营通用web页
                                   if([event.module isEqualToString:@"marketing"] && [event.submodule isEqualToString:@"webpage"]){
                                       
                                       ALWebViewController *webVC = [[ALWebViewController alloc] init];
                                       webVC.view.backgroundColor = [UIColor whiteColor];
                                       webVC.title = @"通用运营web页";
                                       ALAppDelegate *delegate = (ALAppDelegate*)[UIApplication sharedApplication].delegate;
                                       
                                       [delegate.naviController pushViewController:webVC
                                                                          animated:YES];
                                       
                                       NSString *url = [event.queryDict objectForKey:@"weburl"];
                                       url = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                                       NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
                                       [webVC.webView loadRequest:request];
                                       
                                       //此服务已不可用
                                       if([[event.queryDict objectForKey:@"error"] integerValue]==1){
                                           *error = [NSError ALURLErrorWithCode:403
                                                                            msg:@"XXXXX错误"];
                                       }
                                       
                                       if(event.channel==ALURLChannel_InsideURL){
                                           //处理中
                                           if (event.progress) {
                                               NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                               [dict setObject:@"进度50%" forKey:@"descr"];
                                               event.progress(event,0.5,dict);
                                           }
                                           
                                           
                                           
                                           //事件处理完成回调
                                           if (event.completion) {
                                               event.completion(event,@"运营webpage已展示",*error);
                                           }
                                       }
                                       
                                       //如果URL为同步处理过程则需要返回值
                                       return nil;
                                   }
                                   //异步处理运营通用alert页
                                   else if([event.module isEqualToString:@"marketing"] && [event.submodule isEqualToString:@"alert"]){
                                       
                                       UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"通用运营弹框"
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
                                           *error = [NSError ALURLErrorWithCode:403
                                                                            msg:@"XXXXX错误"];

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


@end
