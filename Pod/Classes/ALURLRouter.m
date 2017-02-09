//
//  ALURLRouter.m
//
//  Created by alex on 1/4/16.
//  Copyright (c) 2016 alex. All rights reserved.
//

#import "ALURLRouter.h"
#import "ALURLEvent.h"
#import "NSError+ALURL.h"
#import <objc/runtime.h>

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


/*!
 *  @brief  如果程序通过OpenURL启动,则保存程序启动的ALURLEvent
 */
@property (nonatomic,strong)ALURLEvent *launchALURLEvent;

/*!
 *  @brief  当前如果app初始化工作尚未完成或者其他原因不能继续分发消息则需要暂时保留url,等待完成之后继续分发
 */
@property (nonatomic,strong)ALURLEvent *tempOpenURLEvent;

/**
 *  保存了所有已注册的 URL
 *  结构类似 @{@"beauty": @{@":id": {@"__block", [block copy]}}}
 */
@property (nonatomic) NSMutableDictionary *routes;
@end

@implementation ALURLRouter

#pragma mark - URLPattern管理
- (BOOL)registerURLPattern:(NSString *)URLPattern handler:(ALURLEventHandler)handler{
    return [self addURLPattern:URLPattern andObjectHandler:handler];
}

- (void)deregisterURLPattern:(NSString *)URLPattern{
    [self removeURLPattern:URLPattern];
}

- (BOOL)canCallURL:(NSURL *)URL{
    if (URL) {
        return [self extractParametersFromURL:[URL absoluteString]] ? YES : NO;
    }else{
        return NO;
    }
}

- (BOOL)addURLPattern:(NSString *)URLPattern andObjectHandler:(ALURLEventHandler)handler{
    BOOL cover = NO;
    NSMutableDictionary *subRoutes = [self addURLPattern:URLPattern];
    //如果此节点已经被注册则本次注册将会覆盖上一次注册,调用者需要关注此返回值
    if (subRoutes[ALURL_BLOCK]) {
        cover = YES;
    }
    if (handler && subRoutes) {
        subRoutes[ALURL_BLOCK] = [handler copy];
    }
    return cover;
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

#pragma mark - callInsideURL
- (void)callInsideURL:(NSURL *)URL{
    [self callInsideURL:URL
           withUserInfo:nil
               progress:nil
              completed:nil];
}

- (void)callInsideURL:(NSURL *)URL
         withUserInfo:(NSDictionary *)userInfo
             progress:(ALURLProgressBlcok)progress
            completed:(ALURLCompletedBlcok)completed{
    //URL格式不正确
    if(!URL && completed){
        NSError *error = [NSError ALURLErrorWithCode:ALURLErrorCodeURLInvalid
                                                 msg:@"URL is invalid"];
        completed(nil,nil,error);
    }

    NSMutableDictionary *matcher = [self extractParametersFromURL:[URL absoluteString]];
    ALURLEvent *event = [[ALURLEvent alloc] initWithInsideURL:URL
                                                     userInfo:userInfo
                                                     progress:progress
                                                   completion:completed];
    //NSURL创建失败说明url格式不合法
    if(!event.url){
        if (event.completion) {
            NSError *error = [NSError ALURLErrorWithCode:ALURLErrorCodeURLInvalid
                                                     msg:@"URL format is not valid"];
            event.completion(event,nil,error);
        }
    }
    
#warning 未完成代码
    //通用拦截器:条件判断
    if (self.interceptor && self.interceptor.interceptorBlcok(event,self.interceptor)) {
        //拦截器回调
        self.interceptor.interceptedBlcok(event,self.interceptor);
        [self.interceptor configGoOnBlock:^(ALURLEvent *event, ALURLInterceptor *interceptor) {
            //继续下发消息
            [self distributeALURLEvent:event];
        }];
    }else{
        //立即下发event
        [self distributeALURLEvent:event];
    }
}


#pragma mark - handleOpenURL
/*!
 *  @brief 封装并分发OpenURL
 *  @note  默认不延迟分发
 *
 *  @param url
 *  @param sourceApplication
 *  @param annotation
 *  @param moreInfo 接收到OpenURL时程序自定义的一些附加参数
 *
 *  @return
 */
- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation
                 temp:(BOOL)temp
             moreInfo:(NSDictionary*)moreInfo
     applicationState:(UIApplicationState)applicationState{

    BOOL launch = NO;
    //launchALURLEvent不为空且与当前url相同则此url启动应用
    if (self.launchALURLEvent && [self.launchALURLEvent.url.absoluteString isEqualToString:url.absoluteString]) {
        launch = YES;
        //清空launchALURLEvent
        self.launchALURLEvent = nil;
    }
    
    //外部调起消息封装
    ALURLEvent *event = [[ALURLEvent alloc] initWithOpenURL:url
                                                     source:sourceApplication
                                                 annotation:annotation
                                                   userInfo:moreInfo
                                                     launch:launch
                                           applicationState:applicationState];
    //判断是否属于黑名单则拒绝调用
    //    if([event.sourceApplication isEqualToString:@"XXXXX"]){
    //        return NO;
    //    }
    
    //是否需要暂存
    if(temp){
        //缓存event,等待外部触发distributeTempALURLEvent才下发event
        self.tempOpenURLEvent = event;
    }else{
        //立即下发event
        [self distributeALURLEvent:event];
    }
    return YES;
}

/*!
 *  @brief  程序通过openURL启动,处理application:didFinishLaunchingWithOptions方法的launchOptions
 *  @note   如果openURL启动程序,只保存launchOpenURL,无需向下分发。url会通过handleOpenURL方法传递并分发。
 *
 *  @param  launchOptions 程序启动参数
 *
 */
- (void)handleOpenURLWithLaunchOptions:(NSDictionary*)launchOptions
                              userInfo:(NSDictionary*)userInfo
                      applicationState:(UIApplicationState)applicationState{
    NSString *sourceApplication = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
    NSURL *openURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    
    //如果openURL启动程序,只保存launchOpenURL,无需向下分发
    if (openURL) {
        ALURLEvent *event = [[ALURLEvent alloc] initWithOpenURL:openURL
                                                         source:sourceApplication
                                                     annotation:nil
                                                       userInfo:userInfo
                                                         launch:YES
                                               applicationState:applicationState];
        self.launchALURLEvent = event;
    }
}

/*!
 *  @brief 如果tempOpenURLEvent不为空则将tempOpenURLEvent继续向下分发,然后清空tempOpenURLEvent
 *
 */
- (void)distributeTempOpenURLEvent{
    if(self.tempOpenURLEvent){
        //下发并清空tempOpenURLEvent
        [self distributeALURLEvent:self.tempOpenURLEvent];
        self.tempOpenURLEvent = nil;
    }
}

#pragma mark - Private
/*!
 *  @brief 如果tempOpenURLEvent不为空则将tempOpenURLEvent继续向下分发,然后清空tempOpenURLEvent
 *
 */
- (void)distributeALURLEvent:(ALURLEvent*)event{    
    NSMutableDictionary *matcher = [self extractParametersFromURL:event.url.absoluteString];
    
    //找到接收者并处理
    if (matcher) {
        ALURLEventHandler handler = matcher[ALURL_BLOCK];
        if (event.progress) {
            matcher[ALURLRouterParameterProgress] = event.progress;
        }
        if (event.completion) {
            matcher[ALURLRouterParameterCompletion] = event.completion;
        }
        if (event.userInfo) {
            matcher[ALURLRouterParameterUserInfo] = event.userInfo;
        }
        if (handler) {
            [matcher removeObjectForKey:ALURL_BLOCK];
            
            //保证回调在主线程中执行
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = nil;
                handler(event,&error);
            });
        }
    }
    //此InsideURL未找到匹配者,此消息被丢弃
    else{
        if (event.completion) {
            //保证回调在主线程中执行
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError ALURLErrorWithCode:ALURLErrorCodeNotFound
                                                         msg:@"URL has no handler"];
                event.completion(event,nil,error);
            });
        }
    }
    
    //        //检查并删除已失效的监听者
    //        [self checkDelegateDict];
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

#pragma mark - LaunchOptionsWithOpenURL Test
/*!
 *  @brief 模拟open url启动app所需launchOptions
 *  @note  可在application:didFinishLaunchingWithOptions中给launchOptions赋值用于模拟open url启动app
 *
 *  @return
 */
+(NSMutableDictionary*)launchOptionsWithOpenURL{
    //模拟safari浏览器打开OpenURL
    NSString *sourceApplication = @"com.apple.mobilesafari";
    NSURL *openURL = [NSURL URLWithString:@"alex://com.alex.ALURLRouter-Example/marketing/webpage?weburl=http%3a%2f%2fwww.hao123.com%2f"];
    NSMutableDictionary *launchOptions = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          openURL,UIApplicationLaunchOptionsURLKey,
                                          sourceApplication,UIApplicationLaunchOptionsSourceApplicationKey,nil];
    return launchOptions;
}


@end
