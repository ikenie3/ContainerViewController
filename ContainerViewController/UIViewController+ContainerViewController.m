//
//  UIViewController+ContainerViewController.m
//  ContainerViewController
//
//  Created by ikenie3 on 2015/07/14.
//  Copyright (c) 2015年 ikenie3.org All rights reserved.
//

#import "UIViewController+ContainerViewController.h"
#import <objc/runtime.h>

@implementation UIViewController (ContainerViewController)

# pragma mark - Getter/Setter methods

- (void)_cvc_setViewControllers:(NSMutableArray *)viewControllers {
    objc_setAssociatedObject(self, @"cvc_viewControllers", viewControllers, OBJC_ASSOCIATION_RETAIN);
}

- (NSMutableArray *)_cvc_viewControllers {
    NSMutableArray *array = objc_getAssociatedObject(self, @"cvc_viewControllers");
    if (!array) {
        array = [NSMutableArray array];
    }
    return array;
}


# pragma mark -

- (NSArray *)cvc_viewControllers {
    return [NSArray arrayWithArray:[self _cvc_viewControllers]];
}

- (id)cvc_topViewController {
    return [[self cvc_viewControllers] lastObject];
}

- (BOOL)cvc_isVisibleChildViewController {
    return ([self cvc_topViewController])? YES: NO;
}


# pragma mark - Add/Remove methods

/*
 addChildViewController, removeFromParentViewControllerの詳細
 http://akisute.com/2014/12/container-view-controller.html
 http://quesera2.hatenablog.jp/entry/2014/12/27/163822
 */

- (void)cvc_addChildViewController:(UIViewController *)toViewController
                     containerView:(UIView *)containerView
                       beforeBlock:(CVC_SimpleBlock)beforeBlock
                    animationBlock:(CVC_SimpleBlock)animationBlock
                       finalyBlock:(CVC_SimpleBlock)finalyBlock
                          animated:(BOOL)animated {
    CVC_SimpleBlock beforeCopied = [beforeBlock copy];
    CVC_SimpleBlock animationCopied = [animationBlock copy];
    CVC_SimpleBlock finalyCopied = [finalyBlock copy];
    
    NSMutableArray *array = [self _cvc_viewControllers];
    [array addObject:toViewController];
    [self _cvc_setViewControllers:array];
    
    [self addChildViewController:toViewController];
    
    [toViewController beginAppearanceTransition:YES animated:NO];
    [containerView addSubview:toViewController.view];
    
    void (^before)() = ^{
        if (beforeCopied) {
            beforeCopied();
        }
    };
    void (^block)() = ^{
        toViewController.view.frame = containerView.bounds;
        if (animationCopied) {
            animationCopied();
        }
    };
    void (^finish)() = ^{
        [toViewController didMoveToParentViewController:self];
        [toViewController endAppearanceTransition];
        
        if (finalyCopied) {
            finalyCopied();
        }
    };

    if (animated) {
        before();
        if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:block completion:^(BOOL finished) {
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
            finish();
        }];
    } else {
        before();
        block();
        finish();
    }
}

- (void)cvc_removeViewController:(UIViewController *)fromViewController
                     beforeBlock:(CVC_SimpleBlock)beforeBlock
                  animationBlock:(CVC_SimpleBlock)animationBlock
                     finalyBlock:(CVC_SimpleBlock)finalyBlock
                        animated:(BOOL)animated {
    CVC_SimpleBlock beforeCopied = [beforeBlock copy];
    CVC_SimpleBlock animationCopied = [animationBlock copy];
    CVC_SimpleBlock finalyCopied = [finalyBlock copy];
    
    [fromViewController beginAppearanceTransition:NO animated:NO];
    [fromViewController willMoveToParentViewController:nil];
    
    void (^before)() = [^{
        if (beforeCopied) {
            beforeCopied();
        }
    } copy];
    void (^block)() = [^{
        if (animationCopied) {
            animationCopied();
        }
    } copy];
    void (^finish)() = [^{
        if (finalyCopied) {
            finalyCopied();
        }
        
        // removeFromParentViewControllerを呼ぶとdidMoveToParentViewController:は自動的に実行される
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [fromViewController endAppearanceTransition];
        // ビューコントローラを配列から削除
        NSMutableArray *array = [self _cvc_viewControllers];
        [array removeObject:fromViewController];
        [self _cvc_setViewControllers:array];
    } copy];
    if (animated) {
        before();
        if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        }
        [UIView animateWithDuration:.3f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:block completion:^(BOOL finished) {
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
            finish();
        }];
    } else {
        before();
        block();
        finish();
    }
}

- (void)cvc_pushChildViewController:(UIViewController *)viewController
                      containerView:(UIView *)containerView
                        beforeBlock:(CVC_SimpleBlock)beforeBlock
                     animationBlock:(CVC_SimpleBlock)animationBlock
                        finalyBlock:(CVC_SimpleBlock)finalyBlock
                           animated:(BOOL)animated {
    NSArray *viewControllers = [self cvc_viewControllers];
    UIViewController *fromViewController = [viewControllers lastObject];
    UIViewController *toViewController = viewController;
    
    if (!fromViewController) {
        [self cvc_addChildViewController:toViewController
                           containerView:containerView
                             beforeBlock:beforeBlock
                          animationBlock:animationBlock
                             finalyBlock:finalyBlock
                                animated:animated];
        return;
    }
    
    CVC_SimpleBlock beforeCopied = [beforeBlock copy];
    CVC_SimpleBlock animationCopied = [animationBlock copy];
    CVC_SimpleBlock finalyCopied = [finalyBlock copy];
    __weak __typeof(containerView) containerViewCopied = containerView;
    
    NSMutableArray *array = [self _cvc_viewControllers];
    [array addObject:toViewController];
    [self _cvc_setViewControllers:array];
    
    // 削除予約
    [fromViewController beginAppearanceTransition:NO animated:NO];
    [fromViewController willMoveToParentViewController:nil];
    
    // 追加処理
    [self addChildViewController:toViewController];
    [toViewController beginAppearanceTransition:YES animated:NO];
    [containerView addSubview:viewController.view];
    
    void (^before)() = ^{
        if (beforeCopied) {
            beforeCopied();
        }
    };
    void (^block)() = ^{
        toViewController.view.frame = containerViewCopied.bounds;
        if (animationCopied) {
            animationCopied();
        }
    };
    void (^finish)() = ^{
        // 追加処理の完了
        [toViewController didMoveToParentViewController:self];
        [toViewController endAppearanceTransition];
        
        // 削除処理の完了. pushなので依存関係を維持するためviewControllersからの削除は行わない
        // removeFromParentViewControllerを呼ぶとdidMoveToParentViewController:は自動的に実行される
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [fromViewController endAppearanceTransition];
        
        if (finalyCopied) {
            finalyCopied();
        }
    };
    
    if (animated) {
        before();
        if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:block completion:^(BOOL finished) {
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
            finish();
        }];
    } else {
        before();
        block();
        finish();
    }
}

- (void)cvc_popChildViewControllerBeforeBlock:(CVC_SimpleBlock)beforeBlock
                               animationBlock:(CVC_SimpleBlock)animationBlock
                                  finalyBlock:(CVC_SimpleBlock)finalyBlock
                                     animated:(BOOL)animated {
    NSArray *viewControllers = [self cvc_viewControllers];
    if (viewControllers.count<2) {
        return;
    }
    
    UIViewController *fromViewController = [viewControllers lastObject];
    UIViewController *toViewController = viewControllers[viewControllers.count-2];
    
    CVC_SimpleBlock beforeCopied = [beforeBlock copy];
    CVC_SimpleBlock animationCopied = [animationBlock copy];
    CVC_SimpleBlock finalyCopied = [finalyBlock copy];
    
    // 削除予約
    [fromViewController beginAppearanceTransition:NO animated:NO];
    [fromViewController willMoveToParentViewController:nil];
    
    // 追加処理
    [self addChildViewController:toViewController];
    [toViewController didMoveToParentViewController:self];
    [toViewController beginAppearanceTransition:YES animated:NO];
    UIView *fromView = fromViewController.view;
    [fromView.superview insertSubview:toViewController.view belowSubview:fromView];
    
    void (^before)() = ^{
        if (beforeCopied) {
            beforeCopied();
        }
    };
    void (^block)() = ^{
        if (animationCopied) {
            animationCopied();
        }
    };
    void (^finish)() = ^{
        // 追加処理の完了
        [toViewController didMoveToParentViewController:self];
        
        // 削除処理の完了
        // removeFromParentViewControllerを呼ぶとdidMoveToParentViewController:は自動的に実行される
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [fromViewController endAppearanceTransition];
        
        // ビューコントローラを配列から削除
        NSMutableArray *array = [self _cvc_viewControllers];
        [array removeObject:fromViewController];
        [self _cvc_setViewControllers:array];
        
        if (finalyCopied) {
            finalyCopied();
        }
    };
    
    if (animated) {
        before();
        if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:block completion:^(BOOL finished) {
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
            finish();
        }];
    } else {
        before();
        block();
        finish();
    }
}

- (void)cvc_replaceChildViewController:(UIViewController *)viewController
                         containerView:(UIView *)containerView
                           beforeBlock:(CVC_SimpleBlock)beforeBlock
                        animationBlock:(CVC_SimpleBlock)animationBlock
                           finalyBlock:(CVC_SimpleBlock)finalyBlock
                              animated:(BOOL)animated {
    NSArray *viewControllers = [self cvc_viewControllers];
    UIViewController *fromViewController = [viewControllers lastObject];
    UIViewController *toViewController = viewController;
    
    if (!fromViewController) {
        [self cvc_addChildViewController:toViewController
                           containerView:containerView
                             beforeBlock:beforeBlock
                          animationBlock:animationBlock
                             finalyBlock:finalyBlock
                                animated:animated];
        return;
    }
    
    CVC_SimpleBlock beforeCopied = [beforeBlock copy];
    CVC_SimpleBlock animationCopied = [animationBlock copy];
    CVC_SimpleBlock finalyCopied = [finalyBlock copy];
    __weak __typeof(containerView) containerViewCopied = containerView;
    
    NSMutableArray *array = [self _cvc_viewControllers];
    [array addObject:toViewController];
    [self _cvc_setViewControllers:array];
    
    // 削除予約
    [fromViewController beginAppearanceTransition:NO animated:NO];
    [fromViewController willMoveToParentViewController:nil];
    
    // 追加処理
    [self addChildViewController:toViewController];
    [toViewController beginAppearanceTransition:YES animated:NO];
    [containerView addSubview:viewController.view];
    
    void (^before)() = ^{
        if (beforeCopied) {
            beforeCopied();
        }
    };
    void (^block)() = ^{
        toViewController.view.frame = containerViewCopied.bounds;
        if (animationCopied) {
            animationCopied();
        }
    };
    void (^finish)() = ^{
        // 追加処理の完了
        [toViewController didMoveToParentViewController:self];
        [toViewController endAppearanceTransition];
        
        // 削除処理の完了. pushなので依存関係を維持するためviewControllersからの削除は行わない
        // removeFromParentViewControllerを呼ぶとdidMoveToParentViewController:は自動的に実行される
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [fromViewController endAppearanceTransition];
        
        // ビューコントローラを配列から削除
        NSMutableArray *array = [self _cvc_viewControllers];
        [array removeObject:fromViewController];
        [self _cvc_setViewControllers:array];
        
        if (finalyCopied) {
            finalyCopied();
        }
    };
    
    if (animated) {
        before();
        if (![[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:block completion:^(BOOL finished) {
            if ([[UIApplication sharedApplication] isIgnoringInteractionEvents]) {
                [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            }
            finish();
        }];
    } else {
        before();
        block();
        finish();
    }
}


@end
