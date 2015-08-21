//
//  UIViewController+ContainerViewController.h
//  ContainerViewController
//
//  Created by ikenie3 on 2015/07/14.
//  Copyright (c) 2015年 ikenie3.org All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ CVC_SimpleBlock)();

@interface UIViewController (ContainerViewController)

/**
 @brief 単純にchildViewControllerを追加する処理だけを行う。
 */
- (void)cvc_addChildViewController:(UIViewController *)viewController
                     containerView:(UIView *)containerView
                       beforeBlock:(CVC_SimpleBlock)beforeBlock
                    animationBlock:(CVC_SimpleBlock)animationBlock
                       finalyBlock:(CVC_SimpleBlock)finalyBlock
                          animated:(BOOL)animated;

/**
 @brief 単純にchildViewControllerを削除する処理だけを行う。
 見た目上はchildViewControllerが空になったように見えるが、
 addやpushされたViewControllerは見えなくなっているだけなので注意。
 */
- (void)cvc_removeViewController:(UIViewController *)viewController
                     beforeBlock:(CVC_SimpleBlock)beforeBlock
                  animationBlock:(CVC_SimpleBlock)animationBlock
                     finalyBlock:(CVC_SimpleBlock)finalyBlock
                        animated:(BOOL)animated;

/**
 @brief UINavigationControllerのpushViewControllerと同じように使う
 */
- (void)cvc_pushChildViewController:(UIViewController *)viewController
                      containerView:(UIView *)containerView
                        beforeBlock:(CVC_SimpleBlock)beforeBlock
                     animationBlock:(CVC_SimpleBlock)animationBlock
                        finalyBlock:(CVC_SimpleBlock)finalyBlock
                           animated:(BOOL)animated;

/**
 @brief UINavigationControllerのpopViewControllerと同じように使う。childViewControllerが1つしか無いときはなにもしない。
 */
- (void)cvc_popChildViewControllerBeforeBlock:(CVC_SimpleBlock)beforeBlock
                               animationBlock:(CVC_SimpleBlock)animationBlock
                                  finalyBlock:(CVC_SimpleBlock)finalyBlock
                                     animated:(BOOL)animated;

/**
 @brief childViewControllerを置き換える。表示中のchildViewControllerが無いときはaddする。
 */
- (void)cvc_replaceChildViewController:(UIViewController *)viewController
                         containerView:(UIView *)containerView
                           beforeBlock:(CVC_SimpleBlock)beforeBlock
                        animationBlock:(CVC_SimpleBlock)animationBlock
                           finalyBlock:(CVC_SimpleBlock)finalyBlock
                              animated:(BOOL)animated;

/**
 @return NSArray? ビューコントローラを一覧を返す
 */
- (NSArray *)cvc_viewControllers;
/**
 @return id? 表示中のビューコントローラを返す。モーダルは対応しない。
 */
- (id)cvc_topViewController;
/**
 @return childViewControllerを表示している場合はYES
 */
- (BOOL)cvc_isVisibleChildViewController;


@end
