//
//  ALURLInterceptor.h
//  Pods
//
//  Created by alex on 2017/2/4.
//
//

#import <Foundation/Foundation.h>

@class ALURLInterceptor;
@class ALURLEvent;

/*
 * URL通用拦截器标志, 取值可以是自定义拦截器(字符串)，也可以是以下通用拦截器
 *
 * 登录拦截器 ALURLInterceptorKeyLoginCheck
 *
 */
typedef NSString ALURLInterceptorKey;
extern ALURLInterceptorKey *const ALURLInterceptorKeyLoginCheck;


/*!
 *  @brief 拦截条件
 *
 *  @param event 消息
 *  @param interceptor  拦截器
 */
typedef BOOL (^ALURLInterceptorBlcok)(ALURLEvent *event, ALURLInterceptor *interceptor);


/**
 拦截成功block

 @param event
 @param interceptor
 */
typedef void (^ALURLInterceptedBlcok)(ALURLEvent *event, ALURLInterceptor *interceptor);


typedef void (^ALURLInterceptGoOnBlcok)(ALURLEvent *event, ALURLInterceptor *interceptor);


/**
 通用事件拦截器: 如登陆检查拦截、URL域名白名单+patch+参数、消息上下文环境参数等拦截
 拦截器面向AOP的实例，用于抽象ALURLEventHandler处理回调中的共有通用逻辑。如，登录检查自动进入登录流程
 */
@interface ALURLInterceptor : NSObject

/**
 拦截器唯一标识符
 */
@property (nonatomic, strong) ALURLInterceptorKey *interceptorId;

/**
 拦截器名称
 */
@property (nonatomic, strong) NSString *interceptorName;

/**
 当前最近一次被拦截的事件消息
 */
@property (nonatomic, strong) ALURLEvent *event;

/**
    拦截条件
 */
@property (nonatomic, copy) ALURLInterceptorBlcok interceptorBlcok;

/**
 拦截处理
 处理完成之后需要通过ALURLRouter的distributeALURLEvent方法继续对event进行分发
 */
@property (nonatomic, copy) ALURLInterceptedBlcok interceptedBlcok;


@property (nonatomic, copy) ALURLInterceptGoOnBlcok goOnBlock;



+(ALURLInterceptor*)interceptorWithId:(ALURLInterceptorKey*)interceptorId
                                 name:(NSString*)interceptorName
                            condition:(ALURLInterceptorBlcok)condition
                          intercepted:(ALURLInterceptedBlcok)intercepted;

#pragma mark -  消息继续分发
-(void)configGoOnBlock:(ALURLInterceptGoOnBlcok)goOnBlock;


/**
 拦截器处理完成消息继续分发
 
 @param event 消息体
 */
-(void)eventGoOn:(ALURLEvent*)event;


/**
拦截检查

@param 需要检查的消息

@return BOOL 是否被拦截
*/
-(BOOL)interceptURLEvent:(ALURLEvent*)event;




@end
