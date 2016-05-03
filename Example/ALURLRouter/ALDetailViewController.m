//
//  ALDetailViewController.m
//  ALURLRouter
//
//  Created by alex520biao on 16/5/3.
//  Copyright © 2016年 alex520biao. All rights reserved.
//

#import "ALDetailViewController.h"

@implementation ALDetailViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
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
