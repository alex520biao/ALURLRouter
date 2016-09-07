//
//  ALServiceManager.h
//  ALURLRouter
//
//  Created by alex520biao on 16/5/5.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ALBaseService.h"
#import "ALServiceItem.h"

/*!
 *  @brief 业务模块初始化成功回调
 *
 *  @param service
 */
typedef void (^SetupBlcok)(ALBaseService *service);

@interface ALServiceManager : NSObject

+ (instancetype)sharedInstance;

/*!
 *  @brief 向业务管理器注册
 *
 *  @param aClass    类名
 *  @param serviceId 业务模块唯一编号
 *
 *  @return 注册是否成功
 */
-(BOOL)addService:(Class)aClass serviceId:(ALServiceId*)serviceId;

/**
 *  @brief  根据keyStr获取当前产品线实例
 */
- (id)objectWithServiceId:(ALServiceId *)serviceId;

/**
 *  @brief  根据当前ALServiceItem中的className实例化productDelegate
 */
- (void)setupProducts:(SetupBlcok)block;

@end
