//
//  ALServiceA.m
//  ALURLManager
//
//  Created by alex520biao on 16/4/24.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ALServiceA.h"
#import <ALURLRouter/ALURLRouterKit.h>
#import "ALServiceManager.h"

@implementation ALServiceA

+(void)load{
    
    [[ALServiceManager sharedInstance] addService:[self class] serviceId:@"ALServiceA"];
}

- (void)serviceDidLoad{
    [super serviceDidLoad];
    
    //异步处理过程
    [self.urlRouter registerURLPattern:@"alex://com.alex.ALURLRouter-Example/sercieA"
                            handler:^id(ALURLEvent *event, NSError *__autoreleasing *error) {
                                if([event.module isEqualToString:@"sercieA"] &&[event.submodule isEqualToString:@"action1"]){
                                    //判断消息来源
                                    if(event.channel==ALURLChannel_InsideURL){
                                        //InsideURL
                                        
                                        //处理业务逻辑
                                        
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
                                    }else{
                                        //OpenURL
                                        
                                        //处理业务逻辑
                                        
                                        
                                        return nil;
                                    }
                                }
                                return nil;
                           }];
}

@end
