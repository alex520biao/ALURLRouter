//
//  ALURLInterceptor.m
//  Pods
//
//  Created by alex on 2017/2/4.
//
//

#import "ALURLInterceptor.h"

//URL通用拦截器标志
ALURLInterceptorKey *const ALURLInterceptorKeyLoginCheck = @"ALURLInterceptorKeyLoginCheck";

@interface ALURLInterceptor ()

@end


@implementation ALURLInterceptor

+(ALURLInterceptor*)interceptorWithId:(NSString*)interceptorId
                                 name:(NSString*)interceptorName
                            condition:(ALURLInterceptorBlcok)condition
                          intercepted:(ALURLInterceptedBlcok)intercepted{
    ALURLInterceptor *interceptor = [[ALURLInterceptor alloc] init];
    interceptor.interceptorId = interceptorId;
    interceptor.interceptorName = interceptorName;
    interceptor.interceptorBlcok = condition;
    interceptor.interceptedBlcok = intercepted;
    return interceptor;

}

#pragma mark -  消息继续分发
-(void)configGoOnBlock:(ALURLInterceptGoOnBlcok)goOnBlock{
    self.goOnBlock = goOnBlock;
}


/**
 拦截器处理完成消息继续分发

 @param event 消息体
 */
-(void)eventGoOn:(ALURLEvent*)event{
    if(self.goOnBlock){
        self.goOnBlock(event,self);
    }
}

-(BOOL)interceptURLEvent:(ALURLEvent*)event{
    //判断是否被拦截
    BOOL intercepted = self.interceptorBlcok(event,self);
    if(intercepted){
        self.interceptedBlcok(event,self);
    }
    return intercepted;
}

@end
