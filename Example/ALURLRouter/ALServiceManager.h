//
//  ALServiceManager.h
//  ALURLRouter
//
//  Created by alex520biao on 16/5/5.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ALBaseService.h"


//定义Blocks类型
typedef void (^SetupBlcok)(ALBaseService *service);

@interface ALServiceManager : NSObject

+ (instancetype)sharedInstance;

-(BOOL)addService:(Class)aClass serviceId:(NSString*)serviceId;

/**
 *  @brief  根据keyStr获取当前产品线实例
 */
- (id)productForKeyStr:(NSString *)keyStr;

/**
 *  @brief  根据当前ONEProductItem中的className实例化productDelegate
 */
- (void)setupProducts:(SetupBlcok)block;

@end
