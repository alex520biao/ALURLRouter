//
//  NSError+ALURL.m
//  Pods
//
//  Created by alex520biao on 16/5/6.
//
//

#import "NSError+ALURL.h"

NSString *const ALURLErrorDomain = @"ALURLErrorDomain";
NSInteger const ALURLErrorCodeNotFound = 904;
NSInteger const ALURLErrorCodeURLInvalid = 905;

@implementation NSError (ALURL)

+ (instancetype)ALURLErrorWithCode:(ALURLErrorCode)errorCode
                               msg:(NSString *)errorMsg{
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (errorMsg && errorMsg.length>0) {
        //NSLocalizedDescriptionKey表示错误文本
        [userInfo setObject:errorMsg forKey:NSLocalizedDescriptionKey];
    }
    NSError *error = [NSError errorWithDomain:ALURLErrorDomain
                                         code:errorCode
                                     userInfo:userInfo];
    


    return error;
}

@end
