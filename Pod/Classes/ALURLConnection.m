//
//  ALURLConnection.m
//  Pods
//
//  Created by alex on 2017/2/9.
//
//

#import "ALURLConnection.h"

@implementation ALURLConnection


- (instancetype)initWithInsideURL:(NSURL *)url
                         userInfo:(NSDictionary*)userInfo
                         progress:(ALURLProgressBlcok)progress
                       completion:(ALURLCompletedBlcok)completion{
    self = [super init];
    if (self) {
        if(url){
            _urlEvent = [[ALURLEvent alloc] initWithInsideURL:url
                                                 userInfo:userInfo
                                                 progress:progress
                                               completion:completion];
            _progress = progress;
            _completion = completion;
        }else{
            return nil;
        }
    }
    return self;
}

@end
