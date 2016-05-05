//
//  ALBaseService.h
//  ALURLRouter
//
//  Created by alex520biao on 16/5/5.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ALURLRouter/ALURLRouterKit.h>

/*!
 *  @brief Service业务基类
 */
@interface ALBaseService : NSObject

/*!
 *  @brief  业务模块间通信路由(Service间URL调用)
 */
@property (nonatomic, strong) ALURLRouter *urlRouter;

/*!
 *  @brief service加载完成
 */
- (void)serviceDidLoad;

@end
