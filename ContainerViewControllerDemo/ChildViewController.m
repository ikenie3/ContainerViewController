//
//  ChildViewController.m
//  ContainerViewControllerDemo
//
//  Created by ikenie3 on 2015/08/04.
//  Copyright (c) 2015年 ikenie3.org All rights reserved.
//

#import "ChildViewController.h"

#define LOGD() NSLog(@"%@:%d %s", [[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__)

@interface ChildViewController ()

@end


@implementation ChildViewController

# pragma mark - ChildViewController methods

# pragma mark - UIViewController methods

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    LOGD();
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    LOGD();
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    LOGD();
}

- (void)viewWillLayoutSubviews {
    // do something
    
    [super viewWillLayoutSubviews];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // do something;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    LOGD();
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    LOGD();
}


# pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    LOGD();
}


@end
