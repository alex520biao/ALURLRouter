//
//  ALServiceItem.h
//  ALURLRouter
//
//  Created by alex520biao on 16/5/5.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @brief Service对象的唯一标识符
 */
typedef NSString ALServiceId;

@interface ALServiceItem : NSObject

/**
 *  @brief  产品线唯一标识
 */
@property(nonatomic,copy) ALServiceId *serviceId;

/**
 *  @brief  产品线实体类名
 */
@property(nonatomic, copy) NSString *className;

/**
 *  @brief  className对应的对象实体
 */
@property(nonatomic, strong) id service;


@end
