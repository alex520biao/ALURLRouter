//
//  ALBaseService.h
//  ALURLRouter
//
//  Created by alex520biao on 16/5/5.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ALURLRouter/ALURLRouterKit.h>

@protocol ALBaseServiceProtocol <NSObject>

/*!
 *  @brief service加载完成(子类需要重写)
 */
- (void)serviceDidLoad;

/**
 URL路由
 
 */
- (ALURLRouter*)urlRouter;


@end

/*!
 *  @brief Service业务基类
 */
@interface ALBaseService : NSObject<ALBaseServiceProtocol>

/*!
 *  @brief  业务模块间通信路由(Service间URL调用)
 */
@property (nonatomic, strong) ALURLRouter *urlRouter;

/*!
 *  @brief service加载完成(子类需要重写)
 */
- (void)serviceDidLoad;

@end
