//
//  ALViewController.m
//  ALURLRouter
//
//  Created by alex520biao on 04/27/2016.
//  Copyright (c) 2016 alex520biao. All rights reserved.
//

#import "ALViewController.h"
#import <ALURLRouter/ALURLRouterKit.h>
#import "ALAppDelegate.h"

@interface ALViewController ()

@end

@implementation ALViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btnA1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnA1 setTitle:@"调用sercieA的action1服务" forState:UIControlStateNormal];
    [btnA1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnA1.frame= CGRectMake(10,50,300,50);
    [btnA1 addTarget:self action:@selector(btnA1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnA1];
    
    UIButton *btnA2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnA2 setTitle:@"调用通用webpage服务" forState:UIControlStateNormal];
    [btnA2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnA2.frame= CGRectMake(10,100,300,50);
    [btnA2 addTarget:self action:@selector(btnA2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnA2];
    
    UIButton *btnA3=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnA3 setTitle:@"调用通用alert服务" forState:UIControlStateNormal];
    [btnA3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnA3.frame= CGRectMake(10,150,300,50);
    [btnA3 addTarget:self action:@selector(btnA3Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnA3];
    
    
    UIButton *btnB1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnB1 setTitle:@"调用sercieB1的action1服务" forState:UIControlStateNormal];
    [btnB1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnB1.frame= CGRectMake(10,200,300,50);
    [btnB1 addTarget:self action:@selector(btnB1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnB1];

    UIButton *btnX1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnX1 setTitle:@"http协议URL(Safari浏览器)" forState:UIControlStateNormal];
    [btnX1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnX1.frame= CGRectMake(10,250,300,50);
    [btnX1 addTarget:self action:@selector(btnX1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnX1];
    
    UIButton *btnX2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnX2 setTitle:@"https协议URL(内置浏览器)" forState:UIControlStateNormal];
    [btnX2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnX2.frame= CGRectMake(10,300,300,50);
    [btnX2 addTarget:self action:@selector(btnX2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnX2];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
-(void)btnA1Action:(id)sender{
    ALAppDelegate *delegate = (ALAppDelegate*)[UIApplication sharedApplication].delegate;
    ALServiceC * sercie = delegate.serviceC;
    
    [sercie handleUserAction:0];    
}

-(void)btnA2Action:(id)sender{
    ALAppDelegate *delegate = (ALAppDelegate*)[UIApplication sharedApplication].delegate;
    ALServiceC * sercie = delegate.serviceC;
    
    [sercie handleUserAction:1];    
}

-(void)btnA3Action:(id)sender{
    ALAppDelegate *delegate = (ALAppDelegate*)[UIApplication sharedApplication].delegate;
    ALServiceC * sercie = delegate.serviceC;
    
    [sercie handleUserAction:2];
}

-(void)btnB1Action:(id)sender{
    ALAppDelegate *delegate = (ALAppDelegate*)[UIApplication sharedApplication].delegate;
    ALServiceC * sercie = delegate.serviceC;
    [sercie handleUserAction:2];    
}

-(void)btnX1Action:(id)sender{
    ALAppDelegate *delegate = (ALAppDelegate*)[UIApplication sharedApplication].delegate;
    ALServiceC * sercie = delegate.serviceC;
    [sercie handleUserAction:3];    
}

-(void)btnX2Action:(id)sender{
    ALAppDelegate *delegate = (ALAppDelegate*)[UIApplication sharedApplication].delegate;
    ALServiceC * sercie = delegate.serviceC;
    [sercie handleUserAction:4];
}



@end
