//
//  ALURLEvent.h
//  Pods
//
//  Created by alex520biao on 16/4/5.
//
//

#import <Foundation/Foundation.h>
#import "ALURLProtocol.h"

/*!
 *  @brief InsideURL用于封装跨模块调用的一项服务或功能
 */
@interface ALURLEvent : NSObject

/*!
 *  @brief 原始InsideURL
 */
@property (nonatomic, copy, readonly) NSURL *url;

/*!
 *  @brief URL Scheme,如diditravel
 */
@property (nonatomic, strong, readonly) NSString       *URLScheme;

/*!
 *  @brief  URL Identifier(URL Scheme的名称,一般采用反转域名的方法保证该名字的唯一性: com.company.product)
 *  @note   一般与app的Bundle Identifier保持一致
 */
@property (nonatomic, strong, readonly) NSString       *URLIdentifier;

/*!
 *  @brief  业务分类或服务
 */
@property (nonatomic, strong, readonly) NSString       *servie;

/*!
 *  @brief  页面或动作(一般是打开指定页面)
 */
@property (nonatomic, strong, readonly) NSString       *action;

/*!
 *  @brief URL的query参数
 */
@property (nonatomic, strong, readonly) NSDictionary   *queryDict;

/*!
 *  @brief 用户自定义信息
 */
@property (nonatomic, strong, readonly) NSDictionary *userInfo;

/*!
 *  @brief 消息处理进度block
 */
@property (nonatomic, copy, readonly) ALURLProgressBlcok progress;

/*!
 *  @brief 消息处理结果block
 */
@property (nonatomic, copy, readonly) ALURLCompletedBlcok completion;


- (instancetype)initWithInsideURL:(NSURL *)url
                         userInfo:(NSDictionary*)userInfo
                         progress:(ALURLProgressBlcok)progress
                       completion:(ALURLCompletedBlcok)completion;


@end
