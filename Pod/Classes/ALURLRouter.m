//
//  ALURLRouter.m
//
//  Created by alex on 1/4/16.
//  Copyright (c) 2016 alex. All rights reserved.
//

#import "ALURLRouter.h"
#import "ALURLEvent.h"
#import <objc/runtime.h>

NSString *const ALURLErrorDomain = @"ALURLErrorDomain";
NSInteger const ALURLErrorCodeNotFound = 904;
NSInteger const ALURLErrorCodeURLInvalid = 905;

extern NSString *const ALURLRouterParameterURL;
extern NSString *const ALURLRouterParameterCompletion;
extern NSString *const ALURLRouterParameterUserInfo;

//通配符
static NSString * const ALURL_WILDCARD_CHARACTER = @"~";

//监听者回调block
static NSString * const ALURL_BLOCK = @"__block__";

//发送方参数及block
NSString *const ALURLRouterParameterURL = @"ALURLManagerParameterURL";
NSString *const ALURLRouterParameterUserInfo = @"ALURLManagerParameterUserInfo";
NSString *const ALURLRouterParameterProgress = @"ALURLManagerParameterProgress";
NSString *const ALURLRouterParameterCompletion = @"ALURLManagerParameterCompletion";

@interface ALURLRouter ()
/**
 *  保存了所有已注册的 URL
 *  结构类似 @{@"beauty": @{@":id": {@"__block", [block copy]}}}
 */
@property (nonatomic) NSMutableDictionary *routes;
@end

@implementation ALURLRouter

+ (instancetype)sharedIsntance
{
    static ALURLRouter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}


#pragma mark - URLPattern管理
+ (void)registerURLPattern:(NSString *)URLPattern handler:(ALURLEventHandler)handler{
    [[self sharedIsntance] addURLPattern:URLPattern andObjectHandler:handler];
}

+ (void)deregisterURLPattern:(NSString *)URLPattern{

    [[self sharedIsntance] removeURLPattern:URLPattern];
}

+ (BOOL)canCallURL:(NSString *)URL{
    return [[self sharedIsntance] extractParametersFromURL:URL] ? YES : NO;
}

- (void)addURLPattern:(NSString *)URLPattern andHandler:(ALURLEventHandler)handler{
    NSMutableDictionary *subRoutes = [self addURLPattern:URLPattern];
    if (handler && subRoutes) {
        subRoutes[ALURL_BLOCK] = [handler copy];
    }
}

- (void)addURLPattern:(NSString *)URLPattern andObjectHandler:(ALURLEventHandler)handler{
    NSMutableDictionary *subRoutes = [self addURLPattern:URLPattern];
    if (handler && subRoutes) {
        subRoutes[ALURL_BLOCK] = [handler copy];
    }
}

- (NSMutableDictionary *)addURLPattern:(NSString *)URLPattern
{
    NSArray *pathComponents = [self pathComponentsFromURL:URLPattern];
    
    NSInteger index = 0;
    NSMutableDictionary* subRoutes = self.routes;
    
    while (index < pathComponents.count) {
        NSString* pathComponent = pathComponents[index];
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = [[NSMutableDictionary alloc] init];
        }
        subRoutes = subRoutes[pathComponent];
        index++;
    }
    return subRoutes;
}

- (void)removeURLPattern:(NSString *)URLPattern
{
    NSMutableArray *pathComponents = [NSMutableArray arrayWithArray:[self pathComponentsFromURL:URLPattern]];
    
    // 只删除该 pattern 的最后一级
    if (pathComponents.count >= 1) {
        /*!
         *  @brief 使用KeyPath读取value
         *  @note  如 URLPattern 为 a/b/c, components 就是 @"a.b.c" 正好可以作为 KVC 的 key
         */
        NSString *components = [pathComponents componentsJoinedByString:@"."];
        NSMutableDictionary *route = [self.routes valueForKeyPath:components];
        
        if (route.count >= 1) {
            NSString *lastComponent = [pathComponents lastObject];
            [pathComponents removeLastObject];
            
            // 有可能是根 key，这样就是 self.routes 了
            route = self.routes;
            if (pathComponents.count) {
                NSString *componentsWithoutLast = [pathComponents componentsJoinedByString:@"."];
                route = [self.routes valueForKeyPath:componentsWithoutLast];
            }
            [route removeObjectForKey:lastComponent];
        }
    }
}

#pragma mark - openURL
+ (void)callInsideURL:(NSString *)URL{
    [self callInsideURL:URL
           withUserInfo:nil
               progress:nil
              completed:nil];
}

+ (void)callInsideURL:(NSString *)URL
         withUserInfo:(NSDictionary *)userInfo
             progress:(ALURLProgressBlcok)progress
            completed:(ALURLCompletedBlcok)completed{
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *matcher = [[self sharedIsntance] extractParametersFromURL:URL];
    ALURLEvent *event = [[ALURLEvent alloc] initWithInsideURL:[NSURL URLWithString:URL]
                                                     userInfo:userInfo
                                                     progress:progress
                                                   completion:completed];
    //NSURL创建失败说明url格式不合法
    if(!event.url){
        if (event.completion) {
            NSError *error = [NSError errorWithDomain:ALURLErrorDomain
                                                 code:ALURLErrorCodeURLInvalid
                                             userInfo:nil];
            event.completion(event,nil,error);
        }
    }

    //找到接收者并处理
    if (matcher) {
        ALURLEventHandler handler = matcher[ALURL_BLOCK];
        if (progress) {
            matcher[ALURLRouterParameterProgress] = progress;
        }
        if (completed) {
            matcher[ALURLRouterParameterCompletion] = completed;
        }
        if (userInfo) {
            matcher[ALURLRouterParameterUserInfo] = userInfo;
        }
        if (handler) {
            [matcher removeObjectForKey:ALURL_BLOCK];
            NSError *error = nil;
            handler(event,&error);
        }
    }
    //此InsideURL未找到匹配者,此消息被丢弃
    else{
        if (event.completion) {
            NSError *error = [NSError errorWithDomain:ALURLErrorDomain
                                                 code:ALURLErrorCodeNotFound
                                             userInfo:nil];
            event.completion(event,nil,error);
        }
    }
}

+ (id)callInsideURLSync:(NSString *)URL
           withUserInfo:(NSDictionary *)userInfo
                  error:(NSError **)error{
    ALURLRouter *router = [ALURLRouter sharedIsntance];
    
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *matcher = [router extractParametersFromURL:URL];
    ALURLEventHandler handler = matcher[ALURL_BLOCK];
    
    ALURLEvent *event = [[ALURLEvent alloc] initWithInsideURL:[NSURL URLWithString:URL]
                                                     userInfo:userInfo
                                                     progress:nil
                                                   completion:nil];
    
    //NSURL创建失败说明url格式不合法
    if(!event.url){
        if (event.completion) {
            NSError *error = [NSError errorWithDomain:ALURLErrorDomain
                                                 code:ALURLErrorCodeURLInvalid
                                             userInfo:nil];
            event.completion(event,nil,error);
        }
    }

    //找到接收者并处理
    if(matcher && handler){
        if (userInfo) {
            matcher[ALURLRouterParameterUserInfo] = userInfo;
        }
        [matcher removeObjectForKey:ALURL_BLOCK];
        NSError *errorTemp = nil;
        id ret = handler(event,&errorTemp);
        *error = errorTemp;
        return ret;
    }
    //未找到此InsideURL的匹配者
    else{
        *error = [NSError errorWithDomain:ALURLErrorDomain
                                     code:ALURLErrorCodeNotFound
                                 userInfo:nil];
        return nil;
    }
    return nil;
}

+ (id)callInsideURLSync:(NSString *)URL{
    return [self callInsideURLSync:URL withUserInfo:nil error:nil];
}

#pragma mark - Utils
/*!
 *  @brief 从self.routes中匹配查找URL对应的数据项
 *
 *  @param url
 *
 *  @return
 */
- (NSMutableDictionary *)extractParametersFromURL:(NSString *)url
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    
    parameters[ALURLRouterParameterURL] = url;
    
    NSMutableDictionary* subRoutes = self.routes;
    NSArray* pathComponents = [self pathComponentsFromURL:url];
    
    // borrowed from HHRouter(https://github.com/Huohua/HHRouter)
    for (NSString* pathComponent in pathComponents) {
        BOOL found = NO;
        
        // 对 key 进行排序，这样可以把 ~ 放到最后
        NSArray *subRoutesKeys =[subRoutes.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [obj1 compare:obj2];
        }];
        
        for (NSString* key in subRoutesKeys) {
            if ([key isEqualToString:pathComponent] || [key isEqualToString:ALURL_WILDCARD_CHARACTER]) {
                found = YES;
                subRoutes = subRoutes[key];
                break;
            } else if ([key hasPrefix:@":"]) {
                found = YES;
                subRoutes = subRoutes[key];
                parameters[[key substringFromIndex:1]] = pathComponent;
                break;
            }
        }
        // 如果没有找到该url的pathComponents对应的handler,则直接返回nil
        if (!found && !subRoutes[ALURL_BLOCK]) {
            return nil;
        }
    }
    
    // URL的Query参数
    NSArray* pathInfo = [url componentsSeparatedByString:@"?"];
    if (pathInfo.count > 1) {
        NSString* parametersString = [pathInfo objectAtIndex:1];
        NSArray* paramStringArr = [parametersString componentsSeparatedByString:@"&"];
        for (NSString* paramString in paramStringArr) {
            NSArray* paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count > 1) {
                NSString* key = [paramArr objectAtIndex:0];
                NSString* value = [paramArr objectAtIndex:1];
                parameters[key] = value;
            }
        }
    }
    
    //block
    if (subRoutes[ALURL_BLOCK]) {
        parameters[ALURL_BLOCK] = [subRoutes[ALURL_BLOCK] copy];
    }
    
    //URLEncoding
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, NSString *obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            parameters[key] = [obj stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }];
    
    return parameters;
}

/*!
 *  @brief 根据URL获取路径数组pathComponents
 *
 *  @param URL
 *
 *  @return 路径数组pathComponents
 */
- (NSArray*)pathComponentsFromURL:(NSString*)URL
{
    NSMutableArray *pathComponents = [NSMutableArray array];
    if ([URL rangeOfString:@"://"].location != NSNotFound) {
        NSArray *pathSegments = [URL componentsSeparatedByString:@"://"];
        // 如果 URL 包含协议，那么把协议作为第一个元素放进去
        [pathComponents addObject:pathSegments[0]];
        
        // 如果只有协议，那么放一个占位符
        if ((pathSegments.count == 2 && ((NSString *)pathSegments[1]).length) || pathSegments.count < 2) {
            [pathComponents addObject:ALURL_WILDCARD_CHARACTER];
        }
        
        URL = [URL substringFromIndex:[URL rangeOfString:@"://"].location + 3];
    }
    
    for (NSString *pathComponent in [[NSURL URLWithString:URL] pathComponents]) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:pathComponent];
    }
    return [pathComponents copy];
}

- (NSMutableDictionary *)routes
{
    if (!_routes) {
        _routes = [[NSMutableDictionary alloc] init];
    }
    return _routes;
}

/**
 *  调用此方法来拼接 urlpattern 和 parameters
 *
 *  #define MGJ_ROUTE_BEAUTY @"beauty/:id"
 *  [ALURLManager generateURLWithPattern:MGJ_ROUTE_BEAUTY, @[@13]];
 *
 *
 *  @param pattern    url pattern 比如 @"beauty/:id"
 *  @param parameters 一个数组，数量要跟 pattern 里的变量一致
 *
 *  @return
 */
+ (NSString *)generateURLWithPattern:(NSString *)pattern parameters:(NSArray *)parameters
{
    NSInteger startIndexOfColon = 0;
    NSMutableArray *items = [[NSMutableArray alloc] init];
    NSInteger parameterIndex = 0;
    
    for (int i = 0; i < pattern.length; i++) {
        NSString *character = [NSString stringWithFormat:@"%c", [pattern characterAtIndex:i]];
        if ([character isEqualToString:@":"]) {
            startIndexOfColon = i;
        }
        if (([@[@"/", @"?", @"&"] containsObject:character] || (i == pattern.length - 1 && startIndexOfColon) ) && startIndexOfColon) {
            if (i > (startIndexOfColon + 1)) {
                [items addObject:[NSString stringWithFormat:@"%@%@", [pattern substringWithRange:NSMakeRange(0, startIndexOfColon)], parameters[parameterIndex++]]];
                pattern = [pattern substringFromIndex:i];
                i = 0;
            }
            startIndexOfColon = 0;
        }
    }
    
    return [items componentsJoinedByString:@""];
}

@end
