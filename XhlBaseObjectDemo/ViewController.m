//
//  ViewController.m
//  XhlBaseObjectDemo
//
//  Created by rogue on 2019/1/8.
//  Copyright © 2019 rogue. All rights reserved.
//

#import "ViewController.h"
#import "XhlBaseObject.h"
#import "XhlTableTestController.h"
#import "UIButton+XhlCategory.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *dd = @"22";
    NSString *dddd = Xhl_string(dd);
    NSLog(@"%@", dddd);
    
//    XhlServiceGroup(block)
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"点击" forState:UIControlStateNormal];
    btn.frame = CGRectMake(20, 100, 100, 30);
    btn.backgroundColor = [UIColor grayColor];
    [btn setImage:[UIImage imageNamed:@"location_m"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [btn xhl_layoutButtonWithEdgeInsetsStyle:ButtonEdgeInsetsStyleImageRight imageTitlespace:5];
    
    UITextView  *textVie = [[UITextView alloc] init];
    textVie.xhl_placeholder = @"好的";
    textVie.frame = CGRectMake(20, 200, 100, 100);
    [self.view addSubview:textVie];
//    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
//    button
//    [self.view addSubview:button];
}

- (void)btnd {
    [self.navigationController pushViewController:[XhlTableTestController new] animated:true];
}


@end
