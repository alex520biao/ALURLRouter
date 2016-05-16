//
//  ServiceB.m
//  ALURLManager
//
//  Created by alex520biao on 16/4/24.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ALServiceB.h"
#import <ALURLRouter/ALURLRouterKit.h>
#import "ALServiceManager.h"

@implementation ALServiceB

+(void)load{
    
    [[ALServiceManager sharedInstance] addService:[self class] serviceId:@"ALServiceB"];
}

- (void)serviceDidLoad{
    [super serviceDidLoad];
    
    //ServiceB监听自己相关业务消息
    [self.urlRouter registerURLPattern:@"alex://com.alex.ALURLRouter-Example/sercieB/action1"
                            handler:^id(ALURLEvent *event, NSError *__autoreleasing *error) {
                               //处理中
                               if (event.progress) {
                                   NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                   [dict setObject:@"进度50%" forKey:@"descr"];
                                   event.progress(event,0.5,dict);
                               }
                               
                               //错误信息: 此服务已不可用
                               if([[event.queryDict objectForKey:@"error"] integerValue]==1){
                                   *error = [NSError ALURLErrorWithCode:403
                                                                    msg:@"XXXXX错误"];
                               }
                               
                               //事件处理完成回调
                               if (event.completion) {
                                   event.completion(event,@"已处理完成",*error);
                               }
                               
                               //处理成功返回数据/错误返回nil即可
                               return @"已处理完成";
                           }];
}

@end
