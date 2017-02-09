//
//  ALURLConnection.h
//  Pods
//
//  Created by alex on 2017/2/9.
//
//

#import <Foundation/Foundation.h>
#import "ALURLEvent.h"

/**
 ALURLConnection用于封装ALURL的处理过程,作用类比NSURLConnection
 */
@interface ALURLConnection : NSObject

/**
 ALURL消息
 */
@property (nonatomic, strong)  ALURLEvent *urlEvent;

/*!
 *  @brief 消息处理进度block
 */
@property (nonatomic, copy, readonly) ALURLProgressBlcok progress;

/*!
 *  @brief 消息处理结果block
 */
@property (nonatomic, copy, readonly) ALURLCompletedBlcok completion;


#pragma mark - 构造方法
/*!
 *  @brief 构造InsideURL
 *
 *  @param url
 *  @param userInfo
 *  @param progress
 *  @param completion
 *
 *  @return
 */
- (instancetype)initWithInsideURL:(NSURL *)url
                         userInfo:(NSDictionary*)userInfo
                         progress:(ALURLProgressBlcok)progress
                       completion:(ALURLCompletedBlcok)completion;

@end
