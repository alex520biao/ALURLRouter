//
//  ALWebViewController.m
//  ALURLRouter
//
//  Created by alex520biao on 16/5/3.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ALWebViewController.h"

@interface ALWebViewController ()

@end

@implementation ALWebViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _webView = webView;
    //_webView.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    _webView.detectsPhoneNumbers = YES;//自动检测网页上的电话号码，单击可以拨打
    _webView.autoresizesSubviews = NO; //自动调整大小
    _webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    _webView.backgroundColor = [UIColor clearColor];//清除背景色
    _webView.opaque = NO;//背景不透明设置为NO
//    _webView.delegate=self;
//    UIScrollView *scrollView=(UIScrollView *)[_webView.subviews objectAtIndex:0];//相当于iOS5中开放的scrollView属性
//    scrollView.scrollEnabled=NO;
//    [_webView hideGradientBackground];//去除阴影
    [self.view addSubview:_webView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = YES;
    
    [super viewWillDisappear:animated];
}


@end
