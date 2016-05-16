//
//  ALURLProtocol.h
//  Pods
//
//  Created by alex520biao on 16/4/24.
//
//

#ifndef ALURLProtocol_h
#define ALURLProtocol_h

/*!
 *  @brief  ALURL的来源渠道
 *  @note   区分消息到达客户端的不同场景,客户端需要进行不同的处理。
 */
typedef NS_ENUM(NSInteger, ALURLChannel) {
    /*
     应用内部模块间InsideURL调用
     */
    ALURLChannel_InsideURL,
    
    /*
     应用外部app间OpenURL调用。
     必须经过appdelegate的回调方法-application:didFinishLaunchingWithOptions:和-application:openURL:sourceApplication:annotation:
     */
    ALURLChannel_OpenURL
};


/*!
 *  @brief  AOU消息传递到客户端的场景
 *  @note   区分消息到达客户端的不同场景,客户端需要进行不同的处理。
 */
typedef NS_ENUM(NSInteger, AOUMsgSceneType) {
    /*
     未运行-->前台激活: 应用未运行Notrunning时,用户通过OpenURL消息启动应用。
     处理方式: 客户端需要直接打开消息对应结果页面。
     */
    AOUMsgSceneType_Launch,
    
    /*
     后台/前台非激活-->前台激活 : 应用处于后台Background、挂起Suspended状态、前台非激活Inactive状态时,用户通过OpenURL消息唤醒/调起应用到前台Active。
     处理方式: 客户端需要直接开发消息对应结果页面。
     */
    AOUMsgSceneType_Awake,
    
    /*
     当前已经是前台激活状态: 应用处于前台活跃Active状态,客户端直接收到OpenURL消息
     处理方式: 客户端需要根据当前应用页面和用户行为灵活处理。即可以直接开启消息内容页面,也可以使用可取消弹框、本地通知、其他自定义UI表现方式等非强制性提示手段,用户自行选择是否开启消息对应内容页面。
     */
    AOUMsgSceneType_Active
};


/*!
 *  @brief 任务进度: DCProgress类型为CGFloat,值域为[0~1],超出值域赋值无效
 */
typedef CGFloat ALProgress;

@class ALURLEvent;

/*!
 *  @brief InsideURL事件处理block
 *
 *  @param event 消息
 *  @param error 错误信息
 *
 *  @return
 */
typedef id (^ALURLEventHandler)(ALURLEvent *event,NSError **error);

/*!
 *  @brief InsideURL处理进度
 *
 *  @param event 消息
 *  @param progress 完成进度百分比
 *  @param moreInfo 当前进度的附加信息
 */
typedef void (^ALURLProgressBlcok)(ALURLEvent *event,ALProgress progress,NSDictionary *moreInfo);

/*!
 *  @brief InsideURL处理完成(成功或者异常终止)
 *
 *  @param event 消息
 *  @param result 结果数据对象
 *  @param error  错误对象
 */
typedef void (^ALURLCompletedBlcok)(ALURLEvent *event,id result, NSError *error);


#endif /* ALURLProtocol_h */
