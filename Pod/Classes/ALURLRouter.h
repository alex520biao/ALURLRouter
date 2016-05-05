//
//  ALURLManager.h
//
//  Created by alex on 1/4/16.
//  Copyright (c) 2016 alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALURLProtocol.h"

//ALURL的错误域(类似HttpStatusCode)
FOUNDATION_EXPORT NSString *const ALURLErrorDomain;

//此URL未找到接收者
FOUNDATION_EXPORT NSInteger const ALURLErrorCodeNotFound;

//URL格式不合法
FOUNDATION_EXPORT NSInteger const ALURLErrorCodeURLInvalid;

@class ALURLEvent;


/*!
 *  @brief 使用URL实现应用组件化
 *  @note  部分实现参考借鉴borrowed from HHRouter(https://github.com/Huohua/HHRouter)
 *
 */
@interface ALURLRouter : NSObject


#pragma mark - URLPattern管理
/**
 *  注册并监听URLPattern对应的InsideURL,在handler中进行服务处理即可，需要返回一个 object 给调用方
 *
 *  @param URLPattern 为URL即?前部分(不带参数)，如 app://serviceA/action1
 *  @param handler    URLPattern的处理block
 */
- (void)registerURLPattern:(NSString *)URLPattern handler:(ALURLEventHandler)handler;

/**
 *  撤销某个URL Pattern
 *
 *  @param URLPattern
 */
- (void)deregisterURLPattern:(NSString *)URLPattern;

/**
 *  是否可以调用URL
 *
 *  @param URL
 *
 *  @return
 */
- (BOOL)canCallURL:(NSString *)URL;

#pragma mark - callInsideURL(异步)
/**
 *  调用并执行此URL,没有返回值。会在已注册的 URL -> Handler 中寻找，如果找到，则执行 Handler
 *  @note   此为异步方法
 *
 *  @param URL 带 Scheme，如 app://serviceA/action1。 InsideURL请参考文档。
 */
- (void)callInsideURL:(NSString *)URL;

/**
 *  调用此URL,结果通过异步block返回
 *  @note   此为异步方法
 *
 *  @param URL        带 Scheme 的 URL，如 app://serviceA/action1
 *  @param userInfo   除URL之外的更多信息,必须是非自定义通用类型: 基础类型、系统框架类型(Foundation、UIKit等)、或者是双方模块公有类型
 *  @param progress   URL处理进度的backblock
 *  @param completed  URL处理完成后的backblock
 */
- (void)callInsideURL:(NSString *)URL
         withUserInfo:(NSDictionary *)userInfo
             progress:(ALURLProgressBlcok)progress
            completed:(ALURLCompletedBlcok)completed;

#pragma mark - callInsideURL(同步)
/**
 * 调用此URL并得到一个返回值
 * @note    此方法为同步方法
 *
 *  @param URL
 */
- (id)callInsideURLSync:(NSString *)URL;

/**
 * 调用此URL并得到一个返回值
 * @note    此方法为同步方法
 *
 *  @param URL
 *  @param userInfo 除URL之外的更多信息,必须是非自定义通用类型: 基础数据类型(NSString、NSNumber等)、系统Foundation、UIKit等框架类型(NSData、UIImage等)、或者是双方模块公有类型
 */
- (id)callInsideURLSync:(NSString *)URL
           withUserInfo:(NSDictionary *)userInfo
                  error:(NSError **)error;

@end
