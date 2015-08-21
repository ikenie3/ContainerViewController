//
//  RootViewController.m
//  ContainerViewControllerDemo
//
//  Created by ikenie3 on 2015/08/04.
//  Copyright (c) 2015年 ikenie3.org All rights reserved.
//

#import "RootViewController.h"
#import "ChildViewController.h"
#import "UIViewController+ContainerViewController.h"

#define LOGD() NSLog(@"%@:%d %s", [[NSString stringWithFormat:@"%s", __FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__)

@interface RootViewController ()

@end

@implementation RootViewController

# pragma mark - Action methods

- (IBAction)addButtonPressed:(id)sender {
    ChildViewController *childViewController = [self buildChildViewController];
    __weak __typeof(self) wself = self;
    __weak __typeof(childViewController) wchild = childViewController;
    
    [self cvc_addChildViewController:childViewController
                       containerView:self.containerView
                         beforeBlock:^{
                             CGRect frame = wchild.view.frame;
                             frame.origin.y = CGRectGetHeight(wself.containerView.frame);
                             wchild.view.frame = frame;
                         } animationBlock:^{
                             
                         } finalyBlock:^{
                             
                         } animated:YES];
}

- (IBAction)removeButtonPressed:(id)sender {
    ChildViewController *childViewController = [self cvc_topViewController];
    if (!childViewController) {
        return;
    }
    
    __weak __typeof(self) wself = self;
    __weak __typeof(childViewController) wchild = childViewController;
    [self cvc_removeViewController:childViewController
                         beforeBlock:^{
                         } animationBlock:^{
                             CGRect frame = wchild.view.frame;
                             frame.origin.y = CGRectGetHeight(wself.containerView.frame);
                             wchild.view.frame = frame;
                         } finalyBlock:^{
                         } animated:YES];
}

- (IBAction)pushButtonPressed:(id)sender {
    ChildViewController *childViewController = [self buildChildViewController];
    __weak __typeof(self) wself = self;
    __weak __typeof(childViewController) wchild = childViewController;
    
    [self cvc_pushChildViewController:childViewController
                        containerView:self.containerView
                          beforeBlock:^{
                              CGRect frame = wchild.view.frame;
                              frame.origin.y = CGRectGetHeight(wself.containerView.frame);
                              wchild.view.frame = frame;
                          } animationBlock:^{
                              
                          } finalyBlock:^{
                              
                          } animated:YES];
}

- (IBAction)popButtonPressed:(id)sender {
    ChildViewController *childViewController = [self cvc_topViewController];
    __weak __typeof(self) wself = self;
    __weak __typeof(childViewController) wchild = childViewController;
    [self cvc_popChildViewControllerBeforeBlock:^{
        
    } animationBlock:^{
        CGRect frame = wchild.view.frame;
        frame.origin.y = CGRectGetHeight(wself.view.frame);
        wchild.view.frame = frame;
    } finalyBlock:^{
        
    } animated:YES];
}

- (IBAction)replaceButtonPressed:(id)sender {
    ChildViewController *childViewController = [self buildChildViewController];
    __weak __typeof(self) wself = self;
    __weak __typeof(childViewController) wchild = childViewController;
    [self cvc_replaceChildViewController:wchild containerView:self.containerView beforeBlock:^{
        CGRect frame = wchild.view.frame;
        frame.origin.y = CGRectGetHeight(wself.view.frame);
        wchild.view.frame = frame;
    } animationBlock:^{
    } finalyBlock:^{
    } animated:YES];
}


# pragma mark - Outlet methods

- (ChildViewController *)buildChildViewController {
    ChildViewController *childViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ChildViewController"];
    NSArray *colors = @[ [UIColor redColor], [UIColor blueColor], [UIColor purpleColor], [UIColor magentaColor], [UIColor cyanColor], [UIColor yellowColor],
                         [UIColor grayColor], [UIColor orangeColor] ];
    // 同じ色が連続しないようにする
    static NSInteger index = 0;
    while (true) {
        NSInteger rand = arc4random() % colors.count;
        if (rand != index) {
            index = rand;
            break;
        }
    }
    childViewController.view.backgroundColor = colors[index];
    
    NSLog(@"addChildViewController: %@", childViewController);
    return childViewController;
}


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


@end
