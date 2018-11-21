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
 *  @note   数组元素为ALServiceItem类型
 */
@property (nonatomic, strong, readwrite) NSMutableDictionary *objectConfigDict;

@end

@implementation ALServiceManager

-(NSArray*)services{
    NSMutableArray *array = [NSMutableArray array];
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:self.objectConfigDict];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        ALServiceItem *item = (ALServiceItem *)obj;
        [array addObject:item];
    }];
    return array;
}

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
        _objectConfigDict = [[NSMutableDictionary alloc] init];

    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(BOOL)addService:(Class)aClass serviceId:(ALServiceId*)serviceId{
    if (!aClass) {
        //传入类为空
        return NO;
    }
    
    if (![aClass conformsToProtocol:@protocol(ALBaseServiceProtocol)]) {
        //未实现 ALBaseServiceProtocol 协议!
        return NO;
    }
    
    if (!serviceId || serviceId.length == 0) {
        //serviceId非法
        return NO;
    }
    
    BOOL isExist = [self objectWithServiceId:serviceId] != nil;
    
    if (isExist) {
//        LogError(@"%@ %@ 产品线已存在！", NSStringFromClass(plClass), bid);
        return NO;
    }
    
    ALServiceItem *item = [[ALServiceItem alloc] init];
    item.className = NSStringFromClass(aClass);
    item.serviceId = serviceId;
    [self.objectConfigDict setValue:item forKey:serviceId];
    
    return YES;
}

/**
 *  @brief  根据当前ALServiceItem中的className实例化对象
 */
- (void)setupProducts:(SetupBlcok)block{
    NSDictionary *dict = [NSDictionary dictionaryWithDictionary:self.objectConfigDict];
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
         ALServiceItem *item = (ALServiceItem *)obj;
         
         //根据className实例对象,class必须实现协议
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
- (id)objectWithServiceId:(ALServiceId *)serviceId {
    if (serviceId && [serviceId isKindOfClass:[NSString class]] && serviceId.length > 0) {
        ALServiceItem *item  = [self.objectConfigDict objectForKey:serviceId];
        
        if (item.service) {
            return item.service;
        }
    }
    
    return nil;
}

/**
 *  @brief  根据keyStr获取当前产品线实例
 */
- (ALServiceItem *)productItemForKeyStr:(ALServiceId *)serviceId {
    if (serviceId && [serviceId isKindOfClass:[NSString class]] && serviceId.length > 0) {
        ALServiceItem *item  = [self.objectConfigDict objectForKey:serviceId];
        
        if (item) {
            return item;
        }
    }
    
    return nil;
}


@end
