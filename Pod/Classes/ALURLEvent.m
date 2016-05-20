//
//  ALURLEvent.m
//  Pods
//
//  Created by alex520biao on 16/4/5.
//
//

#import "ALURLEvent.h"

@interface ALURLEvent ()

/*!
 *  @brief 内部URL
 */
@property (nonatomic, copy, readwrite) NSURL *url;

/*!
 *  @brief URL Scheme
 */
@property (nonatomic, copy, readwrite) NSString       *URLScheme;

/*!
 *  @brief  URL Identifier(URL Scheme的名称,一般采用反转域名的方法保证该名字的唯一性: com.didi.passengerApp)
 */
@property (nonatomic, copy, readwrite) NSString       *URLIdentifier;

/*!
 *  @brief  业务分类或模块
 @  @note   URL的一级path
 */
@property (nonatomic, copy, readwrite) NSString       *module;

/*!
 *  @brief  业务子分类或子模块
 @  @note   URL的二级path
 */
@property (nonatomic, copy, readwrite) NSString       *submodule;

/*!
 *  @brief  业务动作(一般是打开指定页面)
 *  @note   URL的三级path
 */
@property (nonatomic, copy, readwrite) NSString       *action;


/*!
 *  @brief URL的query参数
 */
@property (nonatomic, strong, readwrite) NSDictionary   *queryDict;

/*!
 *  @brief 消息处理进度block
 */
@property (nonatomic, copy, readwrite) ALURLProgressBlcok progress;

/*!
 *  @brief InsideURL消息处理结果回调
 */
@property (nonatomic, copy, readwrite) ALURLCompletedBlcok completion;

/*!
 *  @brief  AUEnent事件发起应用的identifier,如: safari浏览器 com.apple.mobilesafari
 *  @note   此字段可以用来动态筛选外部访问入口
 */
@property (nonatomic, strong, readwrite) NSString       *sourceApplication;

/*!
 *  @brief  程序通过此OpenURL启动
 */
@property (nonatomic, assign, readwrite) BOOL           launch;


/*!
 *  @brief 此消息调用渠道 ALURLChannel_InsideURL为应用内调起 / ALURLChannel_OpenURL为外部应用调起
 *
 */
@property (nonatomic, assign, readwrite) ALURLChannel channel;

/*!
 *  @brief  程序通过此OpenURL启动
 */
@property (nonatomic, assign, readwrite) ALURLSceneType sceneType;

/*!
 *  @brief 应用接收到OpenURL时刻的应用状态
 */
@property (nonatomic, assign, readwrite) UIApplicationState applicationState;

/*!
 *  @brief 用户自定义信息
 */
@property (nonatomic, strong, readwrite) NSDictionary *userInfo;


@end

@implementation ALURLEvent


- (instancetype)initWithInsideURL:(NSURL *)url
                         userInfo:(NSDictionary*)userInfo
                         progress:(ALURLProgressBlcok)progress
                       completion:(ALURLCompletedBlcok)completion{
    self = [super init];
    if (self) {
        self.url        = url;
        self.progress   = progress;
        self.completion = completion;
        _userInfo       = userInfo;
        //此消息为InsideURL
        _channel         = ALURLChannel_InsideURL;
        
        if (self.url) {
            //url schemed
            self.URLScheme = self.url.scheme;
            
            //url host
            self.URLIdentifier = self.url.host;
            
            //url path
            if(self.url.path && self.url.path.length >0){
                //module: 一级path
                self.module = [self pathComponentWithIndex:1];
                
                //submodule: 二级path
                self.submodule = [self pathComponentWithIndex:2];
                
                //action: 三级path
                self.action = [self pathComponentWithIndex:3];
            }

            //url queryDict
            NSDictionary *queryDict=[self dictionaryFromQuery:url.query usingEncoding:NSUTF8StringEncoding];
            self.queryDict = queryDict;
        }else{
            return nil;
        }
    }
    return self;
}

/*!
 *  @brief 根据pathComponents的index读取path
 *
 *  @param index
 *
 *  @return
 */
-(NSString*)pathComponentWithIndex:(NSInteger)index{
    NSString *pathComponent = nil;
    if(self.url.path && self.url.path.length >0){
        if (self.url.pathComponents.count>index) {
            pathComponent = [self.url.pathComponents objectAtIndex:index];
        }
    }
    return pathComponent;
}


- (instancetype)initWithOpenURL:(NSURL*)url
                         source:(NSString *)sourceApplication
                     annotation:(id)annotation
                       userInfo:(NSDictionary*)userInfo
                         launch:(BOOL)launch{
    self = [super init];
    if (self) {
        self.sourceApplication = sourceApplication;
        self.url               = url;
        self.launch            = launch;
        _userInfo              = userInfo;
        //此消息为OpenURL
        _channel               = ALURLChannel_OpenURL;
        
        _applicationState = [UIApplication sharedApplication].applicationState;
        if (launch) {
            /*!
             *  @brief 应用未运行,通过OpenURL启动应用
             */
            self.sceneType = ALURLSceneType_Launch;
        }
        else if(_applicationState == UIApplicationStateBackground){
            /*
             此种场景OpenURL应该不会出现
             */
            self.sceneType = ALURLSceneType_Awake;
        }else if(_applicationState == UIApplicationStateInactive){
            /*
             后台/前台非激活-->前台激活 : 应用处于后台Background、挂起Suspended状态、前台非激活Inactive状态时,用户通过OpenURL消息唤醒/调起应用到前台Active。
             每当应用要从一个状态切换到另一个不同的状态时，中途过渡会短暂停留在此状态。
             唯一在此状态停留时间比较长的情况是：当用户锁屏时，用户拉出通知中心列表时或者系统提示用户去响应某些（诸如电话来电、有未读短信等）事件的时候。
             */
            self.sceneType = ALURLSceneType_Awake;
        }else if(_applicationState == UIApplicationStateActive){
            /*
             当前应用正在前台运行，并且接收事件。
             */
            self.sceneType = ALURLSceneType_Active;
        }
        
        if (self.url) {
            //url schemed
            self.URLScheme = self.url.scheme;
            
            //url host
            self.URLIdentifier = self.url.host;
            
            //url path
            if(self.url.path && self.url.path.length >0){
                //module: 一级path
                self.module = [self pathComponentWithIndex:1];
                
                //submodule: 二级path
                self.submodule = [self pathComponentWithIndex:2];
                
                //action: 三级path
                self.action = [self pathComponentWithIndex:3];
            }
            
            //url queryDict
            NSDictionary *queryDict=[self dictionaryFromQuery:url.query usingEncoding:NSUTF8StringEncoding];
            self.queryDict = queryDict;
        }else{
            return nil;
        }
    }
    return self;
}

#pragma mark - queryString生成queryDict
- (NSDictionary*)dictionaryFromQuery:(NSString*)query usingEncoding:(NSStringEncoding)encoding {
    if (query && query.length >0) {
        NSCharacterSet* delimiterSet = [NSCharacterSet characterSetWithCharactersInString:@"&;"];
        NSMutableDictionary* pairs = [NSMutableDictionary dictionary];
        NSScanner* scanner = [[NSScanner alloc] initWithString:query];
        while (![scanner isAtEnd]) {
            NSString* pairString = nil;
            [scanner scanUpToCharactersFromSet:delimiterSet intoString:&pairString];
            [scanner scanCharactersFromSet:delimiterSet intoString:NULL];
            NSArray* kvPair = [pairString componentsSeparatedByString:@"="];
            if (kvPair.count == 2) {
                NSString* key = [[kvPair objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:encoding];
                NSString* value = [[kvPair objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:encoding];
                [pairs setObject:value forKey:key];
            }
        }
        return [NSDictionary dictionaryWithDictionary:pairs];
    }
    return nil;
}

@end
