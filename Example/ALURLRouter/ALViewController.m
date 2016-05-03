//
//  ALViewController.m
//  ALURLRouter
//
//  Created by alex520biao on 04/27/2016.
//  Copyright (c) 2016 alex520biao. All rights reserved.
//

#import "ALViewController.h"
#import <ALURLRouter/ALURLRouterKit.h>

@interface ALViewController ()

@end

@implementation ALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnA1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnA1 setTitle:@"异步调用sercieA的action1服务" forState:UIControlStateNormal];
    [btnA1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnA1.frame= CGRectMake(10,100,300,50);
    [btnA1 addTarget:self action:@selector(btnA1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnA1];
    
    UIButton *btnA2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnA2 setTitle:@"异步调用DCMarketingService的webpage服务" forState:UIControlStateNormal];
    [btnA2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnA2.frame= CGRectMake(10,200,300,50);
    [btnA2 addTarget:self action:@selector(btnA2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnA2];
    
    UIButton *btnA3=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnA3 setTitle:@"异步调用DCMarketingService的alert服务" forState:UIControlStateNormal];
    [btnA3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnA3.frame= CGRectMake(10,300,300,50);
    [btnA3 addTarget:self action:@selector(btnA3Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnA3];
    
    
    UIButton *btnB1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnB1 setTitle:@"同步调用sercieB1的action1服务" forState:UIControlStateNormal];
    [btnB1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnB1.frame= CGRectMake(10,400,300,50);
    [btnB1 addTarget:self action:@selector(btnB1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnB1];

    UIButton *btnX1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnX1 setTitle:@"打开http或https协议URL" forState:UIControlStateNormal];
    [btnX1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnX1.frame= CGRectMake(10,500,300,50);
    [btnX1 addTarget:self action:@selector(btnX1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnX1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)btnA1Action:(id)sender{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"ADSDSAD" forKey:@"userId"];
    
    [ALURLRouter callInsideURL:@"app://identifier/sercieA/action1/a?orderId=123456&error=0"
                         withUserInfo:dict
                             progress:^(ALURLEvent *event, ALProgress progress, NSDictionary *moreInfo) {
                                 NSLog(@"progress");
                             } completed:^(ALURLEvent *event, id result, NSError *error) {
                                 NSLog(@"completed");
                                 
                                 //执行成功
                                 if(!error){
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异步InsideURL: 成功"
                                                                                     message:[NSString stringWithFormat:@"返回值:%@",result]
                                                                                    delegate:nil
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@"OK", nil];
                                     [alert show];
                                 }
                                 //发生异常
                                 else{
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"同步InsideURL: 失败"
                                                                                     message:[NSString stringWithFormat:@"error:%@",[error description]]
                                                                                    delegate:nil
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@"OK", nil];
                                     [alert show];
                                 }
                             }];
}

-(void)btnA2Action:(id)sender{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"ADSDSAD" forKey:@"userId"];
    
    [ALURLRouter callInsideURL:@"app://identifier/marketing/webpage"
                         withUserInfo:dict
                             progress:^(ALURLEvent *event, ALProgress progress, NSDictionary *moreInfo) {
                                 NSLog(@"progress");
                             } completed:^(ALURLEvent *event, id result, NSError *error) {
                                 NSLog(@"completed");
                                 
                                 //执行成功
                                 if(!error){
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异步InsideURL: 成功"
                                                                                     message:[NSString stringWithFormat:@"返回值:%@",result]
                                                                                    delegate:nil
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@"OK", nil];
                                     [alert show];
                                 }
                                 //发生异常
                                 else{
                                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"异步InsideURL: 失败"
                                                                                     message:[NSString stringWithFormat:@"error:%@",[error description]]
                                                                                    delegate:nil
                                                                           cancelButtonTitle:nil
                                                                           otherButtonTitles:@"OK", nil];
                                     [alert show];
                                 }
                             }];
}

-(void)btnA3Action:(id)sender{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"ADSDSAD" forKey:@"userId"];
    
    [ALURLRouter callInsideURL:@"app://identifier/marketing/alert"
                         withUserInfo:dict
                             progress:^(ALURLEvent *event, ALProgress progress, NSDictionary *moreInfo) {
                                 NSLog(@"progress");
                             } completed:^(ALURLEvent *event, id result, NSError *error) {
                                 NSLog(@"completed");
                                 
                                 //执行成功
                                 if(!error){
                                     //...
                                 }
                                 //发生异常
                                 else{
                                     //...
                                 }
                             }];
}

-(void)btnB1Action:(id)sender{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"ADSDSAD" forKey:@"userId"];
    
    
    NSError *error = nil;
    id ret = [ALURLRouter callInsideURLSync:@"app://identifier/sercieB/action1/a?orderId=123456&error=0"
                                      withUserInfo:dict
                                             error:&error];
    
    
    //执行成功
    if(!error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"同步InsideURL: 成功"
                                                        message:[NSString stringWithFormat:@"返回值:%@",ret]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
    //发生异常
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"同步InsideURL: 失败"
                                                        message:[NSString stringWithFormat:@"error:%@",[error description]]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)btnX1Action:(id)sender{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:@"ADSDSAD" forKey:@"userId"];
    
    //打开http或https协议URL
    [ALURLRouter callInsideURL:@"http://xiaojukeji.com/abc"];
    
    NSURL *url = [NSURL URLWithString:@"https://www.hao123.com/"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}



@end
