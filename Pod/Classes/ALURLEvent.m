//
//  DCInsideEvent.m
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
@property (nonatomic, strong, readwrite) NSString       *URLScheme;

/*!
 *  @brief  URL Identifier(URL Scheme的名称,一般采用反转域名的方法保证该名字的唯一性: com.didi.passengerApp)
 */
@property (nonatomic, strong, readwrite) NSString       *URLIdentifier;

/*!
 *  @brief  页面/服务名称
 */
@property (nonatomic, strong, readwrite) NSString       *servie;

/*!
 *  @brief  动作/行为名称
 */
@property (nonatomic, strong, readwrite) NSString       *action;


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
        
        if (self.url) {
            //url schemed
            self.URLScheme = self.url.scheme;
            
            //url host
            self.URLIdentifier = self.url.host;
            
            //url path
            if(self.url.path && self.url.path.length >0){
                //service: 一级path
                if (self.url.pathComponents.count>1) {
                    self.servie = [self.url.pathComponents objectAtIndex:1];
                }
                
                //action: 二级path
                if (self.url.pathComponents.count>2) {
                    self.action = [self.url.pathComponents objectAtIndex:2];
                }
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
