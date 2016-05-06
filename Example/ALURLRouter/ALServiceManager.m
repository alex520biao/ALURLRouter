//
//  ALServiceManager.m
//  ALURLRouter
//
//  Created by alex520biao on 16/5/5.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ALServiceManager.h"
#import "ALServiceItem.h"
#import "ALBaseService.h"

@interface ALServiceManager ()
/**
 *  @brief  产品线类名配置
 *  @note   数组元素为ONEProductItem类型
 */
@property (nonatomic, strong, readwrite) NSMutableDictionary *productConfigDict;

@end

@implementation ALServiceManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ALServiceManager *serviceManager = nil;
    
    dispatch_once(&onceToken, ^{
        serviceManager = [[ALServiceManager alloc] init];
    });
    
    return serviceManager;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _productConfigDict = [[NSMutableDictionary alloc] init];

    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)addService:(Class)aClass serviceId:(NSString*)serviceId{
    if (!aClass) {
        //传入类为空
        return NO;
    }
    
//    if (![class conformsToProtocol:@protocol(ONEBusinessModule)]) {
//        //未实现 ONEBusinessModule 协议!
//        return NO;
//    }
    
//    if (![TRValidJudge isValidString:serviceId]) {
//        LogError(@"bid 非法: [%@]", serviceId);
//        return NO;
//    }
    
    BOOL isExist = [self productForKeyStr:serviceId] != nil;
    
    if (isExist) {
//        LogError(@"%@ %@ 产品线已存在！", NSStringFromClass(plClass), bid);
        return NO;
    }
    
    ALServiceItem *item = [[ALServiceItem alloc] init];
    item.className = NSStringFromClass(aClass);
    item.businessId = serviceId;
    [self.productConfigDict setValue:item forKey:serviceId];
    
    return YES;
}

/**
 *  @brief  根据当前ONEProductItem中的className实例化productDelegate
 */
- (void)setupProducts:(SetupBlcok)block{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:self.productConfigDict];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
         ALServiceItem *item = (ALServiceItem *)obj;
         
         //根据className实例对象,class必须实现ONEBusinessModule协议
         if (!item.service) {
             ALBaseService *service = (ALBaseService*)[[NSClassFromString(item.className) alloc] init];
             item.service = service;
             
             if (block) {
                 block(service);
             }
             
             //productDelegate加载成功
             if ([item.service
                  respondsToSelector:@selector(serviceDidLoad)]) {
                 [item.service serviceDidLoad];
             }
         }
     }];
}

/**
 *  @brief  根据keyStr获取当前产品线实例
 */
- (id)productForKeyStr:(NSString *)keyStr {
    if (keyStr && [keyStr isKindOfClass:[NSString class]] && keyStr.length > 0) {
        ALServiceItem *item  = [self.productConfigDict objectForKey:keyStr];
        
        if (item.service) {
            return item.service;
        }
    }
    
    return nil;
}

/**
 *  @brief  根据keyStr获取当前产品线实例
 */
- (ALServiceItem *)productItemForKeyStr:(NSString *)keyStr {
    if (keyStr && [keyStr isKindOfClass:[NSString class]] && keyStr.length > 0) {
        ALServiceItem *item  = [self.productConfigDict objectForKey:keyStr];
        
        if (item) {
            return item;
        }
    }
    
    return nil;
}


@end
