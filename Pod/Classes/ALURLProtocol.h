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
