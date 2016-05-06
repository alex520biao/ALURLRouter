//
//  NSError+ALURL.h
//  Pods
//
//  Created by alex520biao on 16/5/6.
//
//

#import <Foundation/Foundation.h>

/*!
 *  @brief ALURL的错误域(类似HttpStatusCode)
 */
FOUNDATION_EXPORT NSString *const ALURLErrorDomain;

/*!
 *  @brief URL处理的错误码: 已有ALURLErrorCodeNotFound、ALURLErrorCodeURLInvalid也可以是NSInteger类型任意自定义错误码
 */
typedef NSInteger ALURLErrorCode;

FOUNDATION_EXPORT NSInteger const ALURLErrorCodeURLInvalid;     //URL格式不合法
FOUNDATION_EXPORT NSInteger const ALURLErrorCodeNotFound;       //此URL未找到接收者

/*!
 *  @brief ALURL的错误信息
 *
 *      NSError基础知识:
 *      NSError *error = .....;
 *      NSLog(@"错误域: %@",error.domain);
 *      NSLog(@"错误码: %ld",(long)error.code);
 *      NSLog(@"错误描述: %@",error.localizedDescription);
 *
 */
@interface NSError (ALURL)

/*!
 *  @brief 构造ALURLError对象
 *
 *  @param errorCode 错误码
 *  @param errorMsg  错误描述
 *
 *  @return
 */
+ (instancetype)ALURLErrorWithCode:(ALURLErrorCode)errorCode
                               msg:(NSString *)errorMsg;

@end
