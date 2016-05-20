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
 *  @note  ALURLEvent的URLPath默认分为module、submodule、action三级如果超出请使用pathComponentWithIndex方法自行读取
 */
@interface ALURLEvent : NSObject

#pragma mark - ALURL渠道来源(OpenURL/InsideURL)
/*!
 *  @brief 此消息调用渠道 ALURLChannel_InsideURL为应用内调起 / ALURLChannel_OpenURL为外部应用调起
 *
 */
@property (nonatomic, assign, readonly) ALURLChannel channel;

/*!
 *  @brief 原始URL
 */
@property (nonatomic, copy, readonly) NSURL *url;


#pragma mark - ALURL Common相关

/*!
 *  @brief URL Scheme,如diditravel
 */
@property (nonatomic, copy, readonly) NSString       *URLScheme;

/*!
 *  @brief  URL Identifier(URL Scheme的名称,一般采用反转域名的方法保证该名字的唯一性: com.company.product)
 *  @note   一般与app的Bundle Identifier保持一致
 */
@property (nonatomic, copy, readonly) NSString       *URLIdentifier;

/*!
 *  @brief  业务分类或模块
 @  @note   URL的一级path
 */
@property (nonatomic, copy, readonly) NSString       *module;

/*!
 *  @brief  业务子分类或子模块
 @  @note   URL的二级path
 */
@property (nonatomic, copy, readonly) NSString       *submodule;

/*!
 *  @brief  业务动作(一般是打开指定页面)
 *  @note   URL的三级path
 */
@property (nonatomic, copy, readonly) NSString       *action;


/*!
 *  @brief URL的query参数
 */
@property (nonatomic, strong, readonly) NSDictionary   *queryDict;

/*!
 *  @brief 用户自定义信息
 */
@property (nonatomic, strong, readonly) NSDictionary *userInfo;

/*!
 *  @brief 根据pathComponents的index读取path
 *
 *  @param index  0级为根路径"/",1为一级path,2为二级path,以此类推
 *  @note  如alex://com.alex.ALURLRouter-Example/marketing/alert, 0级path为"/",一级path为"marketing",二级path为"alert"
 *
 *  @return
 */
-(NSString*)pathComponentWithIndex:(NSInteger)index;

#pragma mark - ALURL OpenURL
/*!
 *  @brief  程序通过此OpenURL启动
 */
@property (nonatomic, assign, readonly) BOOL           launch;

/*!
 *  @brief  程序通过此OpenURL启动
 */
@property (nonatomic, assign, readonly) ALURLSceneType sceneType;

/*!
 *  @brief  OpenURL事件发起应用的identifier,如: safari浏览器 com.apple.mobilesafari
 *  @note   此字段可以用来动态筛选外部访问入口,比如允许XX访问,拒绝YY访问,生成外部访问
 */
@property (nonatomic, strong, readonly) NSString       *sourceApplication;

/*!
 *  @brief 应用接收到OpenURL瞬时的应用状态
 */
@property (nonatomic, assign, readonly) UIApplicationState applicationState;


#pragma mark - ALURL InsideURL
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

/*!
 *  @brief 封装application:openURL:sourceApplication:annotation:方法回调的openURL调用参数
 *
 *  @param sourceApplication
 *  @param url
 *  @param annotation
 *
 *  @return
 */
- (instancetype)initWithOpenURL:(NSURL*)url
                         source:(NSString *)sourceApplication
                     annotation:(id)annotation
                       userInfo:(NSDictionary*)userInfo
                         launch:(BOOL)launch;



@end
