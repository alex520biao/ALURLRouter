//
//  ALServiceManager.h
//  ALURLRouter
//
//  Created by alex520biao on 16/5/5.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ALBaseService.h"
#import "ALServiceItem.h"

//定义Blocks类型
typedef void (^SetupBlcok)(ALBaseService *service);

@interface ALServiceManager : NSObject

+ (instancetype)sharedInstance;

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
