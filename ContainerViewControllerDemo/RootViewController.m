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

@interface RootViewController ()

@end


@implementation RootViewController

# pragma mark - Action methods

- (IBAction)addButtonPressed:(id)sender {
    ChildViewController *childViewController = [self buildChildViewController];
    __weak __typeof(self) wself = self;
    [self cvc_addChildViewController:childViewController
                       containerView:self.containerView
                         beforeBlock:^(UIViewController *viewController){
                             CGRect frame = viewController.view.frame;
                             frame.origin.y = CGRectGetHeight(wself.containerView.frame);
                             viewController.view.frame = frame;
                         } animationBlock:^(UIViewController *viewController){
                             
                         } finalyBlock:^(UIViewController *viewController){
                             
                         } animated:YES];
}

- (IBAction)removeButtonPressed:(id)sender {
    ChildViewController *childViewController = [self cvc_topViewController];
    if (!childViewController) {
        return;
    }
    
    __weak __typeof(self) wself = self;
    [self cvc_removeViewController:childViewController
                         beforeBlock:^(UIViewController *viewController){
                             
                         } animationBlock:^(UIViewController *viewController){
                             CGRect frame = viewController.view.frame;
                             frame.origin.y = CGRectGetHeight(wself.containerView.frame);
                             viewController.view.frame = frame;
                         } finalyBlock:^(UIViewController *viewController){
                             
                         } animated:YES];
}

- (IBAction)pushButtonPressed:(id)sender {
    ChildViewController *childViewController = [self buildChildViewController];
    __weak __typeof(self) wself = self;
    [self cvc_pushChildViewController:childViewController
                        containerView:self.containerView
                          beforeBlock:^(UIViewController *fromViewController, UIViewController *toViewController){
                              CGRect frame = toViewController.view.frame;
                              frame.origin.y = CGRectGetHeight(wself.containerView.frame);
                              toViewController.view.frame = frame;
                          } animationBlock:^(UIViewController *fromViewController, UIViewController *toViewController){
                              
                          } finalyBlock:^(UIViewController *fromViewController, UIViewController *toViewController){
                              
                          } animated:YES];
}

- (IBAction)popButtonPressed:(id)sender {
    __weak __typeof(self) wself = self;
    [self cvc_popChildViewControllerBeforeBlock:^(UIViewController *fromViewController, UIViewController *toViewController){
        
    } animationBlock:^(UIViewController *fromViewController, UIViewController *toViewController){
        if (fromViewController) {
            CGRect frame = fromViewController.view.frame;
            frame.origin.y = CGRectGetHeight(wself.view.frame);
            fromViewController.view.frame = frame;
        }
    } finalyBlock:^(UIViewController *fromViewController, UIViewController *toViewController){
        
    } animated:YES];
}

- (IBAction)replaceButtonPressed:(id)sender {
    ChildViewController *childViewController = [self buildChildViewController];
    __weak __typeof(self) wself = self;
    [self cvc_replaceChildViewController:childViewController
                           containerView:self.containerView
                             beforeBlock:^(UIViewController *fromViewController, UIViewController *toViewController){
                                 CGRect frame = toViewController.view.frame;
                                 frame.origin.y = CGRectGetHeight(wself.view.frame);
                                 toViewController.view.frame = frame;
                             } animationBlock:^(UIViewController *fromViewController, UIViewController *toViewController){
                             } finalyBlock:^(UIViewController *fromViewController, UIViewController *toViewController){
                             } animated:YES];
}


# pragma mark - Outlet methods

- (ChildViewController *)buildChildViewController {
    ChildViewController *childViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ChildViewController"];
    NSArray *colors = @[ [UIColor redColor],
                         [UIColor blueColor],
                         [UIColor purpleColor],
                         [UIColor magentaColor],
                         [UIColor cyanColor],
                         [UIColor yellowColor],
                         [UIColor grayColor],
                         [UIColor orangeColor] ];
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}


@end
