//
//  ServiceA.m
//  ALURLManager
//
//  Created by alex520biao on 16/4/24.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ServiceA.h"
#import <ALURLRouter/ALURLRouterKit.h>

@implementation ServiceA

- (instancetype)init
{
    self = [super init];
    if (self) {
        //异步处理过程        
        [ALURLRouter registerURLPattern:@"app://identifier/sercieA/action1"
                                handler:^id(ALURLEvent *event, NSError *__autoreleasing *error) {
                                   //处理中
                                   if (event.progress) {
                                       NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                                       [dict setObject:@"进度50%" forKey:@"descr"];
                                       event.progress(event,0.5,dict);
                                   }
                                   
                                   //此服务已不可用
                                   if([[event.queryDict objectForKey:@"error"] integerValue]==1){
                                       *error = [NSError errorWithDomain:ALURLErrorDomain
                                                                    code:ALURLErrorCodeNotFound
                                                                userInfo:nil];
                                   }
                                   
                                   //事件处理完成回调
                                   if (event.completion) {
                                       event.completion(event,@"已处理完成",*error);
                                   }
                                   
                                   //如果URL为同步处理过程则需要返回值
                                   return nil;
                               }];
    }
    return self;
}

@end
